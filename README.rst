Terraform template for swarm docker cluster with master and one slave
=====================================================================

Requirements
------------

credentials/credentials.tfvars::


  aws_access_key = "access_key"
  aws_secret_key = "secret_key"
  developer = "Name/Surename"

credentials/ssh/::


  id_rsa
  id_rsa.pem
  id_rsa.pub

Running
-------

locally::


  $ ./terraform_local.sh init/plan/apply

In docker container::


  $ ./terraform_docker.sh init/plan/apply
