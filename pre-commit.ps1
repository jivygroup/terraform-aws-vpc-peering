$TAG = "latest"
docker run --rm -v ${pwd}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:$TAG run -a

terraform init -upgrade
terraform validate
terraform test