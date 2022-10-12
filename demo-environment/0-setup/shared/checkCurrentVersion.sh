#!/bin/zsh
echo -e "Checking if local Kong custom Docker image is current"
unset DOCKER_COMPOSE_DEMO_ENV_NEW_VERSION
if [ ! -f ~/.demo-env/.latest_docker_compose_version ]; then
  echo -e "No previous custom Kong image found - will rebuild the Docker image"
  export  DOCKER_COMPOSE_DEMO_ENV_NEW_VERSION="true"
elif ! cmp -s ~/.demo-env/.latest_docker_compose_version current_kong_version.txt; then
  echo -e "Current version of custom Kong image is different - rebuiding the image" 
  export  DOCKER_COMPOSE_DEMO_ENV_NEW_VERSION="true"
fi
cd Kong-Custom-Image
. ./update-docker-image-and-custom-plugins.sh
cd ..

# echo -e "Checking if local kumactl is latest Kong Mesh version"
# LATEST_VERSION=https://docs.konghq.com/mesh/latest_version/
# VERSION=$(curl -s $LATEST_VERSION)
# INSTALLED_MESH_VERSION=$( bash <<EOF
#   kumactl version
# EOF
# )
# echo -e "Hello"
# if [[ "$INSTALLED_MESH_VERSION" != "Kong Mesh: $VERSION" ]]; then
#   echo -e "kumactl is not installed, not current, not the Enterprise version or not in your PATH"
#   echo -e "Installed: $INSTALLED_MESH_VERSION" 
#   echo -e "Latest: Kong Mesh: $VERSION"
#   echo -e "Please run \"install_local_mesh_binaries.sh\" in the 9-scripts/mesh folder"
# fi
