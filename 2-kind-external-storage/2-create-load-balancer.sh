#!/bin/bash

###############################################################################
# Run a development load balancer that allows you to get an external IP address
# This enables you to plan deployments using the same concepts as cloud systems
###############################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Quit early if the process is already running, such as when installing multiple clusters
#
EXISTING_PROCESS=$(ps -ef | grep '[c]loud-provider-kind')
if [ "$EXISTING_PROCESS" != '' ]; then
  echo 'Load balancer is already running'
  exit 0
fi

#
# Calculate operating system specific values
#
VERSION='0.4.0'
if [ "$(uname -m)" == 'arm64' ]; then
  ARCH='arm64'
else
  ARCH='amd64'
fi

case "$(uname -s)" in

  Darwin)
    PLATFORM='darwin'
  ;;

  MINGW64*)
    PLATFORM='windows'
  ;;

  Linux)
    PLATFORM='linux'
  ;;
esac
FILENAME="cloud-provider-kind_${VERSION}_${PLATFORM}_${ARCH}.tar.gz"
FILEPATH="https://github.com/kubernetes-sigs/cloud-provider-kind/releases/download/v${VERSION}/${FILENAME}"

#
# Download the executable
#
echo 'Downloading cloud-provider-kind as a development load balancer ...'
rm -rf download 2>/dev/null
mkdir download
cd download
curl -s -L -O $FILEPATH
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading the load balancer archive'
  exit 1
fi

#
# Unzip it
#
tar -zxf $FILENAME
if [ $? -ne 0 ]; then
  echo '*** Problem encountered unpacking the load balancer archive'
  exit 1
fi

#
# Run the load balancer, which requires sudo on macOS or a Run as administrator shell on Windows
#
LOADBALANCER=$(docker ps | grep envoyproxy | awk '{print $1}')
if [ "$LOADBALANCER" != '' ]; then
  docker kill $LOADBALANCER 2>/dev/null
fi
if [ "$PLATFORM" == 'darwin' ]; then
  echo 'Grant permissions to cloud-provider-kind to add an IP address to the loopback network interface ...'
  sudo ./cloud-provider-kind
else
  ./cloud-provider-kind
fi
