provider "aws" {
  region = "us-east-1"
  profile = "fiapeats"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "eks-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw"
  }
}

# Route Table
resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = {
    Name = "eks-route-table"
  }
}

resource "aws_route_table_association" "eks_route_table_assoc" {
  subnet_id      = aws_subnet.eks_subnet.id
  route_table_id = aws_route_table.eks_route_table.id
}


resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eks-sg"
  }
}


resource "aws_instance" "eks_node" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.eks_subnet.id
  vpc_security_group_ids = [
    aws_security_group.eks_sg.id
  ]
  tags = {
    Name = "eks-node"
  }
}


resource "local_file" "eks_yaml_files" {
  content = <<EOF
  ${file("k8s/dashboard.yaml")}
  ${file("k8s/deployment.yaml")}
  ${file("k8s/metrics.yaml")}
  ${file("k8s/secrets.yaml")}
  ${file("k8s/configMap.yaml")}
  ${file("k8s/hpa.yaml")}
  ${file("k8s/ingress.yaml")}
  ${file("k8s/service.yaml")}
  ${file("k8s/service_eks.yaml")}
  ${file("k8s/userAdmin.yaml")}
EOF
  filename = "eks_files.yaml"
}


output "ec2_instance_public_ip" {
  value = aws_instance.eks_node.public_ip
}

output "eks_yaml_files_path" {
  value = local_file.eks_yaml_files.filename
}
