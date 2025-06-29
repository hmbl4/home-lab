
variable "ubuntu_sydney" {
  description = "AMI ID for Sydney Ubuntu"
  type        = string
  default     = "ami-0df7a207adb9748c7"
}

# Core VPC and Subnets


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true 
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = false 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# Security groups:

resource "aws_security_group" "secure_access" {
  name        = "restricted-access"
  description = "Restricted SG for SSH HTTP Wazuh Suricata"
  vpc_id      = aws_vpc.main.id

  # SSH - only from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["115.188.97.164/32"]
    description = "SSH access from Henrys IP only"
  }

  # HTTP - open to the world
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from anywhere"
  }

  # Wazuh TCP agent (default port 1514)
  ingress {
    from_port   = 1514
    to_port     = 1514
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Wazuh TCP agent traffic from VPC"
  }

  # Wazuh/Syslog UDP 514
  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Syslog UDP from VPC"
  }

  # Suricata NetFlow (UDP 2055)
  ingress {
    from_port   = 2055
    to_port     = 2055
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "NetFlow traffic for Suricata"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "secure-access"
  }
}

# Key pair creation

resource "aws_key_pair" "henry" {
  key_name   = "fake-key"
  public_key = file("fake_id_rsa.pub") 
}

# Ubuntu instance

resource "aws_instance" "web" {
  ami           = var.ubuntu_sydney
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.secure_access.id]

  key_name = aws_key_pair.henry.key_name

  tags = {
     Name = "web-instance"
  }
}

resource "aws_s3_bucket_versioning" "log-threat-intel" {

  bucket = "henry-threat-intel-bucket"

  versioning_configuration {
    status = "Enabled"
  }

}
