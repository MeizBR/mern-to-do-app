module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.26.0"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.29"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    app = "myapp"
  }

  eks_managed_node_groups = [
    {
        instance_type = "t2.micro"
        name = "worker-group-1"
        desired_capacity     = 3
        min_size             = 1
        max_size             = 4
    }
  ]
}

data "aws_eks_cluster" "myapp-cluster" {
    name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "myapp-cluster" {
    name = module.eks.cluster_name
}

provider "kubernetes" {
    load_config_file = "false"
    host = data.aws_eks_cluster.myapp-cluster.endpoint
    token = data.aws_eks_cluster_auth.myapp-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.myapp-cluster.endpoint
}