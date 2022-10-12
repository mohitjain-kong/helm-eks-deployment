# Setup
This scripts automatically installs:

- Postgres database
- a Kong gateway deployment (three nodes by default)
- Ingress controller
- httpbin
- JSONPlaceholder

# Running minikube using HyperKit for OS X
If you would like to run Kong inside of Kubernetes without install VirtualBox, please follow the instructions below.

- Make sure you have Docker Desktop installed
- Follow the instructions for loading minikube here: https://kubernetes.io/docs/tasks/tools/install-minikube/
- Note: You do not have to install HyperKit because it is already installed when you install Docker Desktop, Run `which hyperkit` to verify it is installed
- Run `brew install docker-machine-driver-hyperkit`
- Start Minikube: `minikube start --vm-driver hyperkit --memory 6128`
- Start kong demo-environment: `. ./kong.sh start minikube`
- You may get an error asking for you to change permissions for the docker-machine-driver-hyperkit. Just follow the instructions in the console.
