locals {
  acm_app_cert_arn = lookup(data.terraform_remote_state.dns.outputs, "acm_app_cert_${local.region_short_name}_arn", null)
}

resource "aws_lb" "public" {
  name               = "${var.app_name}-${local.region_short_name}-public-lb"
  load_balancer_type = "application"

  subnets         = data.terraform_remote_state.environment.outputs.public_subnets
  security_groups = [module.ecs_instance_alb_sg.security_group_id]

  tags = merge(local.tags, {
    Name             = "${var.app_name}-${local.region_short_name}-public-lb",
    VantaDescription = "${var.app_name}-${local.region_short_name}-${var.account}-public-lb"
  })
}

resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.public_acm_cert.this_acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }

  tags = merge(local.tags, {
    Name             = "${var.app_name}-${local.region_short_name}-public-https",
    VantaDescription = "${var.app_name}-${local.region_short_name}-${var.account}-public-https-listener"
  })
}

resource "aws_lb_listener_certificate" "this" {
  listener_arn    = aws_lb_listener.public_https.arn
  certificate_arn = module.public_acm_cert.this_acm_certificate_arn
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(local.tags, {
    Name             = "${var.app_name}-${local.region_short_name}-public-http",
    VantaDescription = "${var.app_name}-${local.region_short_name}-${var.account}-public-http-lb"
  })
}
