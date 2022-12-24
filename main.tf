module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

data "local_file" "ssh_key" {
  filename = "${path.module}/ssh-key.pub"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "terraform_local_key_file" {
  key_name   = "terraform_local_key_file"
  public_key = data.local_file.ssh_key.content
}

resource "aws_instance" "wordpress_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "terraform_local_key_file"
  tags = {
    Name = "wordpress_server"
  }
  subnet_id              = module.networking.public_subnets_ids[0]
  vpc_security_group_ids = [aws_security_group.main.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/shaycraft/.ssh/id_rsa_aws_terraform_tutorial")
    timeout     = "4m"
  }
}

resource "aws_security_group" "main" {
  vpc_id = module.networking.vpc_id
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "SSH Port"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "HTTP port"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "HTTPS port"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    }
  ]
}