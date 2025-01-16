resource "aws_instance" "web" {
  ami = "ami-0b0ea68c435eb488d"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.public_http_traffic.id ]
  subnet_id = aws_subnet.public-subnet.id
  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp3"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags,{
    name = "web-server"
  })
}

resource "aws_security_group" "public_http_traffic" {
  description = "security group allowing traffic on port 443"
  name = "public-http-traffic"
  vpc_id = aws_vpc.custom-vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

