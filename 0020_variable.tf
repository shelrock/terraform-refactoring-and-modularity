#####################################
# ami ids list ucmp 공용 계정용 환경설정
# id , key 는 TFC Variable에 등록됨
#####################################

variable "ami_list" {
  type    = list(string)
  default = ["list1"]
}
variable "ami_ownerid" {
  default = ""
}
variable "ucmp-access-key" {
  default = ""
}
variable "ucmp-access-secret" {
  default   = ""
  sensitive = true
}
variable "ami_env" {
  default = "prod"
}

#####################
# default tag
#####################
variable "env" {
  default = "prd"
}

variable "pjt" {
  default = "wer" //Web Eks Rds
}

variable "costc" {
  default = "prd_wer"
}

#####################
# s3
#####################
variable "bucket_serial" {
  default = "0001"
}

#####################
# vpc
#####################
variable "region" {
  type    = string
  default = "ap-northeast-2"
}

# variable "az_a" {
#   default = "ap-northeast-2a"
# }

# variable "az_c" {
#   default = "ap-northeast-2c"
# }

### 수정 ###
data "aws_region" "current" {} # aws provider에서 
                               # 현재 region을 가져오기 위한 data source
locals {
  az_a  = "${data.aws_region.current.name}a" # 현재 region에 따라 az를 동적으로 가져오기 위해 data source 사용
  az_c  = "${data.aws_region.current.name}c" # 현재 region에 따라 az를 동적으로 가져오기 위해 data source 사용
}



# variable "vpc_cidr" {
#   type    = string
#   default = "100.64.0.0/16"
# }

variable "vpc_cidr" {
  type    = string
  default = "100.64.0.0/16"
  description = "VPC의 CIDR 정의, 16비트 대역을 입력 (e.g. 100.64.0.0/16)"
  validation {
  condition      = contains(split("/", var.vpc_cidr), "16")
  error_message  = "CIDR은 16비트"
  }
}


#####################
# subnet
#####################
# RDB cluster 구조로 인한  default 값 변경

variable "puba_cidr" {
  type    = string
  default = "100.64.0.0/20"
}

variable "pubc_cidr" {
  default = "100.64.64.0/20"
}

variable "pria_cidr" {
  default = "100.64.16.0/20"
}

variable "pric_cidr" {
  default = "100.64.80.0/20"
}

variable "pria_db_cidr" {
  default = "100.64.32.0/20"
}

variable "pric_db_cidr" {
  default = "100.64.96.0/20"
}

variable "pria_tgw_cidr" {
  default = "100.64.48.0/20"
}

##################################### multi AZ 고민중
# variable "pric_tgw_cidr" {
#   default = "100.64.112.0/20"
# }
#####################################


#####################
# eks-node
#####################
variable "node_instance_types" {
  default = "t3.small"
  # default = "m5.2xlarge"  # 설계 시 정한 값
}

variable "node_disk_size" {
  default = 100
}

variable "scailing_desired" {
  description = "scailing config. initially desired size"
  default     = 1
}

variable "scailing_max" {
  description = "scailing config. max size" ### max size needs to bigger than 0 (>= 1)
  default     = 3
}

variable "scailing_min" {
  description = "scailing config. min size"
  default     = 1
}

#####################
# ecr
#####################
variable "image_tag_mutability" {
  description = "동일 이미지 태그 덮어쓰기 가능여부, MUTABLE: 가능/ IMMUTABLE: 불가능"
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "리포지토리에 푸시된 후 각 이미지 보안취약점을 자동으로 스캔 여부"
  default     = false
}

#####################
# bastion-ec2
#####################
variable "key_name" {
  default = "bastion-key"
}

#variable "bastion_ami" {
#  default = "ami-0a0de518b1fc4524c"
#}

variable "bastion_type" {
  default = "t2.micro"
  ## default = "t3.medium" # 설계 시 정한 값
}

variable "bastion_cidr_block" {
  description = "bastion 서버 ingress 허용하는 cidr_block"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#####################
# db_aurora_mysql
#####################

variable "db_engine" {
  default = "aurora-mysql"
}

variable "db_engine_version" {
  default = "5.7.mysql_aurora.2.07.2"
}

variable "db_engine_mode" {
  default = "provisioned"
}

variable "db_name" {
  description = "DB이름. 대문자 필수"
  default     = "SERVICE"
}

variable "db_instance_class" {
  default = "db.t3.small"
  #  default = "db.m5.large"
}

variable "db_port" {
  default = "3306"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "db_character_set_name" {
  default = "UTF8"
}

variable "db_timezone_set_name" {
  default = "Asia/Seoul"
}

#####################
# db - parameter group
#####################

variable "db_family" {
  description = "db parameter group family"
  type        = string
  default     = "aurora-mysql5.7"
}


#####################
# iam - users per groups
#####################

variable "CloudArchitectureTeam_users" {
  description = "Create IAM CloudArchitectureTeam Users"
  type        = list(any)
  default = [
    "hello@lguplus.co.kr",
    "lg@lguplus.co.kr",
    "uplus@lguplus.co.kr"
  ]
}

variable "developer_group_users" {
  description = "Create IAM Developer Group Users"
  type        = list(any)
  default = [
    "dev1@lgupluspartners.co.kr",
    "dev2@lgupluspartners.co.kr",
    "dev3@lgupluspartners.co.kr",
  ]
}

#####################
# iam - group policies
#### MFA 강제화 정책 추가 고려
#####################

variable "CloudArchitectureTeam_policy" {
  description = "CloudArchitectureTeam policy"
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "developer_group_policy" {
  description = "Developer Group policy"
  type        = list(any)
  default = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    // "arn:aws:iam::**********:policy/MFA_Device"
  ]
}