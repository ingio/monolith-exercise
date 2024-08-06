# Go Application API Server

Main file in `cmd` folder

Docker file using alpine image

Example make commands

```sh
# start application
make start

# build application
make build

# build docker image
make build_image
```

See make file for more options

# build infrastructure
Build from local machine

```sh
cd azure/terraform/
terraform init
terraform plan
terraform apply
```

# helmify
```sh
helmify -f ./templates/deployment.yaml myhelm
```

# Helm Chart install

```sh
# install helm chart
helm install monolith ./myhelm --namespace monolith --create-namespace --set name=monolith -f ./myhelm/values.yaml

# upgrade with value file that has increased replica count
helm upgrade monolith ./myhelm --namespace monolith --set name=monolith -f ./myhelm/values.yaml

# clean up
helm uninstall monolith -n monolith
```

# How to cope with high demand
Add Azure Application Gateway v2, with WAF preferably.  
Enable the autoscale and set the max instances so it can grow on demand.  
Add nginx ingress controller using internal load balancer on static ip and add that as backend pool for the application gateway.  
Change the service in the deployment to use nginx ingress with domain name.  
