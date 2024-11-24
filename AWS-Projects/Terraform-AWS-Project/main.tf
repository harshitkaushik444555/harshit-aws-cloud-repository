resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

}

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "rta-1" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.my-rt.id

}


resource "aws_route_table_association" "rta-2" {
  subnet_id      = aws_subnet.sub-2.id
  route_table_id = aws_route_table.my-rt.id
}

resource "aws_security_group" "my-sg" {
  name   = "my-sg"
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    description = "Http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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
    name = "my-sg"
  }



}

resource "aws_instance" "my-ec2-1" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id              = aws_subnet.sub-1.id
  user_data              = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "my-ec2-2" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id              = aws_subnet.sub-2.id
  user_data              = base64encode(file("userdata2.sh"))
}

#create alb
resource "aws_lb" "my-alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.my-sg.id]
  subnets         = [aws_subnet.sub-1.id, aws_subnet.sub-2.id]

  tags = {
    name = "my-alb"
  }
}


resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }



}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.my-ec2-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.my-ec2-2.id
  port             = 80
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}


