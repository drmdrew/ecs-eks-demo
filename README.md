# ecs-eks-demo

Small demo project for experimenting with ECS and EKS.

## Prerequisites

S3 bucket for terraform state
```
aws --profile dev --region us-east-1 s3 mb s3://drmdrew.ca-ecs-eks-demo
make_bucket: drmdrew.ca-ecs-eks-demo
```
```
aws --profile dev --region us-east-1 s3api put-bucket-versioning --bucket drmdrew.ca-ecs-eks-demo --versioning-configuration 'MFADelete=Disabled,Status=Enabled'    
```

Run terraform in docker
```
docker run --rm -it -v $HOME/.aws:/home/terraform/.aws -v $(pwd):/terraform drmdrew/terraform init
```

