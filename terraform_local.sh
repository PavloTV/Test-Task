#!/usr/bin/env bash

./terraform $* -var-file="credentials/credentials.tfvars"
