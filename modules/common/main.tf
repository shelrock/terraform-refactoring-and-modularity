



module "common" {
  source = "./modules/common"

  env = var.env
  pjt = var.pjt
  vpc_cidr = "100.64.0.0/16"
}


locals {
  cluster_tags = {
	  #eks(managed) 가 node 생성되는 서브넷을 찾을 수 있도록 tag 추가 
    "kubernetes.io/cluster/eks-${var.env}-${var.pjt}-cluster" = "shared",
  }
}

resource "aws_subnet" "puba" {
  availability_zone       = local.az_a
  # vpc_cidr를 4개의 subnet으로 나누고, 0번째 subnet을 선택
  cidr_block              = cidrsubnet(aws_vpc.common.cidr_block,4, 0) 
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true # 자동 퍼블릭IP 할당 여부

  tags = merge(local.cluster_tags, tomap({ # 로컬 변수 선언된 태그 병합 
    Name        = "sbn-${var.env}-${var.pjt}-puba",
    Service     = "puba",

    "kubernetes.io/role/elb" = "1"
  }))
}


# NAT 용 eip 생성 (NAT가 2개, eip도 각각 생성)
# resource "aws_eip" "eip_nat_puba" {
#   vpc        = true                       # EIP가 VPC에 있는지 여부
#   depends_on = [aws_internet_gateway.igw] # igw 생성 이후 가능하기에 의존성 추가함
#   tags = {
#     Name    = "eip-${var.env}-${var.pjt}-nat-puba"
#     Service = "nat-puba"
#   }
# }

# Bastion 용 eip 생성
# resource "aws_eip" "eip_bastion" {
#   vpc        = true                       # EIP가 VPC에 있는지 여부
#   depends_on = [aws_internet_gateway.igw] # igw 생성 이후 가능하기에 의존성 추가함
#   tags = {
#     Name    = "eip-${var.env}-${var.pjt}-bastion"
#     Service = "bastion"
#   }
# }

# az별 NAT public subnet에 생성
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.eip_nat_puba.id
  subnet_id     = aws_subnet.sbn_puba.id
  depends_on    = [aws_internet_gateway.igw] # igw 생성 이후 가능하기에 의존성 추가함
  tags = {
    Name    = "nat-${var.env}-${var.pjt}-puba",
    Service = "puba"
  }
}