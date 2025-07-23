variable "aws_region" {
  default = "us-east-1"
}

variable "docker_image_url" {
  description = "Docker image URL from DockerHub"
  type        = string
}

variable "container_port" {
  default = 8080
}
