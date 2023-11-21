TAG=latest
docker run -e "USERID=$(id -u):$(id -g)" -v $(pwd):/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:$TAG run -a

#terraform test