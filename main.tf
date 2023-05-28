// norada pakalpojumu sniedzeju
provider "aws" {
  region = "eu-north-1"
}
// norada instances parametrus
resource "aws_instance" "example" {
  ami           = "ami-01ed9b769ca66f1aa"
  instance_type = "t3.micro"
  key_name      = "kartupelis"
  vpc_security_group_ids = ["sg-0dae04546b4ffb089"]
  tags = {
    Name = var.ec2_name
  }

}
// 30 sekunzu pauze pec instances izveidosanas
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.example]

  create_duration = "30s"
}
resource "null_resource" "execute_commands" {
  triggers = {
    // norada ja sie mainigie ir mainijusies, tad sis darbibas atkartojas
    pullfe_command = var.pullfe_command,
  }

  depends_on = [
        aws_instance.example,
        time_sleep.wait_30_seconds,
        ]
        // nosuta failu uz instanci
    provisioner "file" {
    source      = "docker-compose.yaml"
    destination = "docker-compose.yml"
    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.pem_file)
      host        = aws_instance.example.public_ip
    }
  }
  // izvieto docker bildi uz instances
  provisioner "remote-exec" {
    inline = [
      var.pullfe_command,
      var.deploy_command
    ]
    // savienojuma konfiguracija
    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.pem_file)
      host        = aws_instance.example.public_ip
    }
  }
}
// izveido failu ar instances ip adresi
resource "local_file" "jenkins_ip_file" {
  content  = aws_instance.example.public_ip
  filename = "ip_file"
}
// norada mainigos
variable "pem_file" {
  type = string
}
variable "pullfe_command" {
  type = string
}
variable "deploy_command" {
  type = string
}
variable "ec2_name" {
  type = string
}