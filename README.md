# ecs-eks-demo

Small demo project for experimenting with ECS and EKS.

## Prerequisites

S3 bucket for terraform state
```
S3_BUCKET=drmdrew.ca-ecs-eks-demo
aws --profile dev --region us-east-1 s3 mb s3://$S3_BUCKET
```
You should see output like this except referring to the S3_BUCKET name you have chosen:
```
make_bucket: drmdrew.ca-ecs-eks-demo
```

I usually enable S3 bucket versioning at this point:
```
aws --profile dev --region us-east-1 s3api put-bucket-versioning \
  --bucket $S3_BUCKET \
  --versioning-configuration 'MFADelete=Disabled,Status=Enabled'
```

## Run terraform in docker

I prefer to run terraform via a docker image. The examples
shown here use the terraform docker image defined in
https://github.com/drmdrew/dockerfiles/tree/master/terraform

```
docker run --rm -it -v $HOME/.aws:/home/terraform/.aws -v $(pwd):/terraform \
  drmdrew/terraform init
```
You can also `docker pull` this terraform image from docker hub
(it has an auto-buid):
```
docker pull drmdrew/terraform:latest
```

To make running a dockerized terraform easier there is a small set of shell helper functions defined
in `deploy-funcs.sh`:
```
source ./deploy-funcs.sh
cd terraform
terraform-docker init -backend-config=bucket=$S3_BUCKET
```

Once you've done a terraform init you can do a plan/apply:
```
cd terraform
terraform-docker apply
```

When EKS is up and running you can run kubectl from inside the docker
container too, e.g.:
```
terraform-docker-kubectl  describe services
```
