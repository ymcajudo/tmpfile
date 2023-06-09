# docker를 제어하기 위해 docker provider 설정
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}


provider "docker" {
}


# 도커 이미지 지정
resource "docker_image" "ubuntu" {
  name         = "ubuntu:20.04"
}


# head 노드 구성
resource "docker_container" "head" {
  image = docker_image.ubuntu.image_id
  name  = "head"


  # hold the container not to exit immediately
  command = ["tail", "-f", "/dev/null"]


  # 호스트의 현재 디렉터리를 컨테이너 내부의 /shared 에 공유
  volumes {
    container_path = "/shared"
    host_path = path.cwd
    read_only = false
  }


  # execute a command inside the container with docker command
  # test purpose
  provisioner "local-exec" {
    command = "docker exec ${self.id} hostname"
  }
}


resource "docker_container" "compute01" {
  image = docker_image.ubuntu.image_id
  name  = "compute01"
  command = ["tail", "-f", "/dev/null"]
}


resource "docker_container" "compute02" {
  image = docker_image.ubuntu.image_id
  name  = "compute02"
  command = ["tail", "-f", "/dev/null"]
}
