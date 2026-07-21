
module "common" {
  source   = "./modules/common"
  env      = var.env
  pjt      = var.pjt
  vpc_cidr = "100.64.0.0/16"

  # Add any required variables for the common module here
}


locals {
  az_a = "ap-northeast-2a" # 또는 변수로 변경 필요
  cluster_tags = {
    # eks(managed)가 생성되는 서브넷을 찾을 수 있도록 tags 추가
    "kubernetes.io/cluster/eks-${var.env}-${var.pjt}-cluster" = "shared",
  }
}

resource "aws_subnet" "puba" {
  availability_zone       = local.az_a
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, 0)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true # 자동 퍼블릭 IP 할당 여부

  tags = merge(local.cluster_tags, tomap({ #로컬 변수 선언된 태그 병합
    Name                     = "sbn-${var.env}-${var.pjt}-puba",
    Service                  = "puba"
    "kubernetes.io/role/elb" = "1"
  }))
}
