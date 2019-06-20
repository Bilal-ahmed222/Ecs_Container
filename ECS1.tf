resource "aws_ecs_cluster" "mycluster" {
  name = "mycluster"
}

resource "aws_ecs_task_definition" "mytaskdefination" {
  family                = "mytaskdefination"
  container_definitions = "${file("task-definitions/service.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "on demand"

  tags = {
    Name = "main"
  }

}

resource "aws_subnet" "web1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "web2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_instance" "Test1" {
  ami           = "ami-0d09143c6fc181fe3"
  instance_type = "t2.micro"
  subnet_id = "subnet-0a974d0dca03eb6fb"
  
 }

  resource "aws_instance" "Test2" {
  ami           = "ami-0d09143c6fc181fe3" 
  instance_type = "t2.micro"
  subnet_id = "subnet-0eaf903b5f9d8e0c5"
  
  }

resource "aws_ecs_service" "mytestservice" {
  name            = "mytestservice"
  cluster         = "${aws_ecs_cluster.foo.id}"
  task_definition = "${aws_ecs_task_definition.mongo.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.foo.arn}"
  depends_on      = ["aws_iam_role_policy.foo"]

}


  resource "aws_ecr_repository" "foo" {
  name = "mydockerrepo"
  
  
  }
  
  resource "aws_lb" "test" {
  name               = "myALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${sg-0ca28a727ba1158a2}"]
  
  
  }

data "aws_arn" "ecr_repository" {
  arn = "518460391922.dkr.ecr.us-east-1.amazonaws.com/mydockerrepo:latest"

}


   