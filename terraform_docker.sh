#!/bin/bash

docker run --rm -v $PWD:/data hashicorp/terraform:light $* -var-file="credentials/credentials.tfvars"
