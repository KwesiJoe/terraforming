resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnets" {
  depends_on = [ aws_vpc.vpc ]
  for_each = var.subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

resource "aws_security_group" "alb" {
  name = "alb"

    ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  

  egress {
    description      = "tcp from VPC"
    from_port        = 8002
    to_port          = 8002
    protocol         = "tcp"
    cidr_blocks      = [ aws_vpc.vpc.cidr_block ]
  }

    egress {
    description      = "tcp from VPC"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = [ aws_vpc.vpc.cidr_block ]
  }
}

resource "aws_security_group" "rds" {
  name = "rds"
  vpc_id = aws_vpc.vpc.id

	ingress {
    description      = "rds from vpc"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = [ aws_vpc.vpc.cidr_block ]
	}

    egress {
    description      = "rds goes everywhere from vpc"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "ssh" {
  name = "ssh"
  vpc_id = aws_vpc.vpc.id

	ingress {
    description      = "ssh from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
	}

    egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "ecs" {
  name = "ecs"
  vpc_id = aws_vpc.vpc.id

  	ingress {
    description      = "ecs from anywhere"
    from_port        = 8002
    to_port          = 8002
    protocol         = "tcp"
    cidr_blocks      = [ aws_vpc.vpc.cidr_block ]
	}

  	ingress {
    description      = "ecs from anywhere"
    from_port        = 8888
    to_port          = 8888
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
	}

    egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

