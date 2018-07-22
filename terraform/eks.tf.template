module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "eks-1"
  subnets               = ["${module.vpc.private_subnets}"]
  vpc_id                = "${module.vpc.vpc_id}"
}
