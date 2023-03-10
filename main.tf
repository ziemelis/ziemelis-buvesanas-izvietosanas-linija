provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "example" {
  ami           = "ami-047932622d41b1a1b"
  instance_type = "t3.micro"
  key_name      = "kartupelis"
  vpc_security_group_ids = ["sg-0dae04546b4ffb089"]
  tags = {
    Name = "Deploy Test Server"
  }
}
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.example]

  create_duration = "30s"
}
resource "null_resource" "execute_commands" {

  depends_on = [
        aws_instance.example,
        time_sleep.wait_30_seconds,
        ]

  provisioner "remote-exec" {
    inline = [
      var.pull_command,
      var.deploy_command
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.pem_file)
      host        = aws_instance.example.public_ip
    }
  }
}
variable "pem_file" {
  type = string
}
variable "pull_command" {
  type = string
}
variable "deploy_command" {
  type = string
}
