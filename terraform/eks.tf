module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "eks-1"
  subnets               = ["${module.vpc.private_subnets}"]
  vpc_id                = "${module.vpc.vpc_id}"
  workers_group_defaults = {
    name                 = "count.index" # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.
    ami_id               = ""            # AMI ID for the eks workers. If none is provided, Terraform will search for the latest version of their EKS optimized worker AMI.
    asg_desired_capacity = "1"           # Desired worker capacity in the autoscaling group.
    asg_max_size         = "3"           # Maximum worker capacity in the autoscaling group.
    asg_min_size         = "1"           # Minimum worker capacity in the autoscaling group.
    instance_type        = "t2.medium"   # Size of the workers instances.
    spot_price           = ""            # Cost of spot instance.
    root_volume_size     = "100"         # root volume size of workers instances.
    root_volume_type     = "gp2"         # root volume type of workers instances, can be 'standard', 'gp2', or 'io1'
    root_iops            = "0"           # The amount of provisioned IOPS. This must be set with a volume_type of "io1".
    key_name             = ""            # The key name that should be used for the instances in the autoscaling group
    pre_userdata         = ""            # userdata to pre-append to the default userdata.
    additional_userdata  = ""            # userdata to append to the default userdata.
    ebs_optimized        = true          # sets whether to use ebs optimization on supported types.
    enable_monitoring    = true          # Enables/disables detailed monitoring.
    public_ip            = false         # Associate a public ip address with a worker
    kubelet_node_labels  = ""            # This string is passed directly to kubelet via --node-labels= if set. It should be comma delimited with no spaces. If left empty no --node-labels switch is added.
    subnets              = ""            # A comma delimited string of subnets to place the worker nodes in. i.e. subnet-123,subnet-456,subnet-789
  }
}

data "external" "aws_iam_auth_token" {
  program = ["sh", "${path.module}/aws-iam-auth-token.sh"]

  query {
    cluster_name = "${module.eks.cluster_id}"
  }
}

provider "kubernetes" {
  host                   = "${module.eks.cluster_endpoint}"
  cluster_ca_certificate = "${base64decode(module.eks.cluster_certificate_authority_data)}"
  token                  = "${data.external.aws_iam_auth_token.result.token}"
  load_config_file       = false
}