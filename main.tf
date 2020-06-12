provider "aws" {
  version = "~> 2.32"
  region     = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.subnet
  tags = {
    Name = var.project_name
  }
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet
  availability_zone = "${var.region}${var.zone}"
  tags = {
    Name = "Main subnet (${var.project_name})"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-route-table"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "ec2_instance" {
  name = "${var.project_name}-ec2-instance"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_access_ip_range_of_clients}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-instance-sg"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "server" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name

  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_instance.id]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 30
  }
  tags = {
      Name = "${var.project_name}-server"
  }
}

output "instance_ip_addr" {
  value = aws_instance.server.public_ip
}
