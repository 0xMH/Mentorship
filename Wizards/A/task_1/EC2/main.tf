
resource "aws_instance" "this" {
    count = length(var.subnet_ids)
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = element(var.subnet_ids , count.index)
    vpc_security_group_ids = [var.security_group_id]
    key_name = data.aws_key_pair.bastion_key.key_name

    # force change 
    user_data_replace_on_change = true

    # FIND ANOTHER WAY
    user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y

    # Install Docker
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker

    # Add ubuntu user to docker group
    usermod -aG docker ubuntu

    docker run -d -p 8080:8080 -e SITE_NAME=SITE-${count.index} --restart unless-stopped ${var.docker_image_url}
    EOF

}


data "aws_key_pair" "bastion_key" {
    key_name = var.key_name
}