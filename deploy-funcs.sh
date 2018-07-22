#!/bin/bash

function terraform-docker {
  docker run --rm -it \
    -v $HOME/.aws:/home/terraform/.aws \
    -v $(pwd):/terraform \
    drmdrew/terraform $*
}

function terraform-docker-kubectl {
  docker run --rm -it \
    -v $HOME/.aws:/home/terraform/.aws \
    -v $(pwd):/terraform \
    -e KUBECONFIG=/terraform/kubeconfig_eks-1 \
    --entrypoint kubectl \
    drmdrew/terraform $*
}

function terraform-docker-kubectl-proxy {
  docker run --rm -it \
    -v $HOME/.aws:/home/terraform/.aws \
    -v $(pwd):/terraform \
    -e KUBECONFIG=/terraform/kubeconfig_eks-1 \
    -p 8001:8001 \
    --entrypoint kubectl \
    drmdrew/terraform proxy --address 0.0.0.0
}

function terraform-docker-shell {
  docker run --rm -it \
    -v $HOME/.aws:/home/terraform/.aws \
    -v $(pwd):/terraform \
    --entrypoint ash \
    drmdrew/terraform $*
}


