provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "example" {
  ami           = "ami-047932622d41b1a1b"
  instance_type = "t3.micro"
  key_name      = "kartupelis"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0dae04546b4ffb089"]
  tags = {
    Name = "Deploy Test Server"
  }
}
  resource "aws_eip_association" "example" {
  instance_id   = aws_instance.example.id
  allocation_id = "eipalloc-099d85f4e1ef5b3fd"
}
