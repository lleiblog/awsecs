#--------------
# ecs  TokyoTest
#--------------
# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TokyoTest"
  }
}

# Subnet
# --------------------
resource "aws_subnet" "public_1a" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "TokyoTest-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id = "${aws_vpc.main.id}"

  availability_zone = "ap-northeast-1c"

  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "TokyoTest-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id = "${aws_vpc.main.id}"

  availability_zone = "ap-northeast-1d"

  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "TokyoTest-public-1d"
  }
}

# Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id = "${aws_vpc.main.id}"

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "TokyoTest-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id = "${aws_vpc.main.id}"

  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.20.0/24"

  tags = {
    Name = "TokyoTest-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id = "${aws_vpc.main.id}"

  availability_zone = "ap-northeast-1d"
  cidr_block        = "10.0.30.0/24"

  tags = {
    Name = "TokyoTest-private-1d"
  }
}
  
# --------------------  
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "TokyoTest"
  }
}  
# --------------------
# Elasti IP
# --------------------

# --------------------
# NAT Gateway
# --------------------
resource "aws_eip" "nat_1a" {
  vpc = true

  tags = {
    Name = "TokyoTest-natgw-1a"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = "${aws_subnet.public_1a.id}"
  allocation_id = "${aws_eip.nat_1a.id}"

  tags = {
    Name = "TokyoTest-1a"
  }
}


resource "aws_eip" "nat_1c" {
  vpc = true

  tags = {
    Name = "TokyoTest-natgw-1c"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  subnet_id     = "${aws_subnet.public_1c.id}"
  allocation_id = "${aws_eip.nat_1c.id}"

  tags = {
    Name = "TokyoTest-1c"
  }
}

resource "aws_eip" "nat_1d" {
  vpc = true

  tags = {
    Name = "TokyoTest-natgw-1d"
  }
}

resource "aws_nat_gateway" "nat_1d" {
  subnet_id     = "${aws_subnet.public_1d.id}"
  allocation_id = "${aws_eip.nat_1d.id}"

  tags = {
    Name = "TokyoTest-1d"
  }
}

# --------------------
# Route Table
# --------------------
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "TokyoTest-public"
  }
}

# Route

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

# Association

resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = "${aws_subnet.public_1c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = "${aws_subnet.public_1d.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Route Table (Private)

resource "aws_route_table" "private_1a" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "TokyoTest-private-1a"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "TokyoTest-private-1c"
  }
}

resource "aws_route_table" "private_1d" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "TokyoTest-private-1d"
  }
}

# Route (Private)
resource "aws_route" "private_1a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1a.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_1a.id}"
}

resource "aws_route" "private_1c" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1c.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_1c.id}"
}

resource "aws_route" "private_1d" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1d.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_1d.id}"
}

# Association (Private)
resource "aws_route_table_association" "private_1a" {
  subnet_id      = "${aws_subnet.private_1a.id}"
  route_table_id = "${aws_route_table.private_1a.id}"
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = "${aws_subnet.private_1c.id}"
  route_table_id = "${aws_route_table.private_1c.id}"
}

resource "aws_route_table_association" "private_1d" {
  subnet_id      = "${aws_subnet.private_1d.id}"
  route_table_id = "${aws_route_table.private_1d.id}"
}

# --------------------
# SecurityGroup
# --------------------

resource "aws_security_group" "alb" {
  name        = "TokyoTest-alb"
  description = "TokyoTest alb"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TokyoTest-alb"
  }
}

# SecurityGroup Rule
resource "aws_security_group_rule" "alb_http" {
  security_group_id = "${aws_security_group.alb.id}"

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}


# --------------------
# 2-1 
# --------------------
# --------------------
# ALB
# --------------------
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "TokyoTest"

  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1c.id}", "${aws_subnet.public_1d.id}"]
}


# --------------------
# Listener
# --------------------
resource "aws_lb_listener" "main" {

  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = "${aws_lb.main.arn}"
  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

# --------------------
# ecs
# --------------------
# --------------------
# Task Definition
# --------------------
resource "aws_ecs_task_definition" "main" {
  family = "TokyoTest"
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"
  network_mode = "awsvpc"
#  task_role_arn            = "arn:aws:iam::781730070740:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::781730070740:role/ecsTaskExecutionRole"
  container_definitions = <<EOL
[
  {
    "name": "nginx"
  # "image": "nginx:1.14",
  # test ecr image
    "image": "781730070740.dkr.ecr.ap-northeast-1.amazonaws.com/hello-ecr",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOL
}

# ELB Target Group
resource "aws_lb_target_group" "main" {
  name = "TokyoTest"
  vpc_id = "${aws_vpc.main.id}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  health_check = {
    port = 80
    path = "/"
  }
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "main" {
  listener_arn = "${aws_lb_listener.main.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "TokyoTest"
}

# -----------------------
# SecurityGroup
# -----------------------

resource "aws_security_group" "ecs" {
  name        = "TokyoTest-ecs"
  description = "TokyoTest ecs"
  vpc_id      = "${aws_vpc.main.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TokyoTest-ecs"
  }
}

# SecurityGroup Rule
resource "aws_security_group_rule" "ecs" {
  security_group_id = "${aws_security_group.ecs.id}"
  type = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

# ECS Service
resource "aws_ecs_service" "main" {
  name = "TokyoTest"
  depends_on = ["aws_lb_listener_rule.main"]
  cluster = "${aws_ecs_cluster.main.name}"
  launch_type = "FARGATE"
  desired_count = "1"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  network_configuration = {
    subnets         = ["${aws_subnet.private_1a.id}", "${aws_subnet.private_1c.id}", "${aws_subnet.private_1d.id}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer = [
    {
      target_group_arn = "${aws_lb_target_group.main.arn}"
      container_name   = "nginx"
      container_port   = "80"
    },
  ]
}

#------------------
# SSL/TLS certificates
#------------------

variable "domain" {
  type        = "string"

  #fix domain:
  default = "llei.org"
}

# Route53 Hosted Zone
data "aws_route53_zone" "main" {
  name         = "${var.domain}"
  private_zone = false
}

# ACM
resource "aws_acm_certificate" "main" {
  domain_name = "${var.domain}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 record
resource "aws_route53_record" "validation" {
  depends_on = ["aws_acm_certificate.main"]

  zone_id = "${data.aws_route53_zone.main.id}"

  ttl = 60

  name    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.main.domain_validation_options.0.resource_record_value}"]
}

# ACM Validate
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = "${aws_acm_certificate.main.arn}"

  validation_record_fqdns = ["${aws_route53_record.validation.0.fqdn}"]
}

# Route53 record
resource "aws_route53_record" "main" {
  type = "A"

  name    = "${var.domain}"
  zone_id = "${data.aws_route53_zone.main.id}"

  alias = {
    name                   = "${aws_lb.main.dns_name}"
    zone_id                = "${aws_lb.main.zone_id}"
    evaluate_target_health = true
  }
}

# ALB Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.main.arn}"

  certificate_arn = "${aws_acm_certificate.main.arn}"

  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "http_to_https" {
  listener_arn = "${aws_lb_listener.main.arn}"

  priority = 99

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["${var.domain}"]
  }
}

# Security Group Rule
resource "aws_security_group_rule" "alb_https" {
  security_group_id = "${aws_security_group.alb.id}"

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# test url  https://llei.org   ---->ok
