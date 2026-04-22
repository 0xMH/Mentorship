# It create one target group for now
# TODO: 
# Make it more general in comming versions

resource "aws_alb" "this" {
    name = var.name
    internal = var.internal
    load_balancer_type = var.load_balancer_type
    security_groups = var.security_groups
    subnets = var.subnets
}


resource "aws_alb_target_group" "tg" {
    name = "${var.name}-tg"
    port = var.target_port
    protocol = var.protocol
    vpc_id = var.vpc_id
    target_type = var.target_instance
}

resource "aws_alb_target_group_attachment" "tg_attachment" {
    count = length(var.target_ids)
    target_group_arn = aws_alb_target_group.tg.arn
    target_id = element(var.target_ids , count.index)

}

resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_alb.this.arn
    port = var.listener_port
    protocol = var.protocol
    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.tg.arn
    }
}