#!/bin/bash

##################################################
# A basic Docker deployment of Wordpress and MySQL
##################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# First build the custom docker image
#
docker build -t custom_mysql:9.1.0 .
if [ $? -ne 0 ]; then
  echo '*** Problem encountered building the database server docker image'
  exit 1
fi

#
# Ensure that the system is down
#
docker compose down

#
# Clear any existing data
#
sudo rm -rf data 2>/dev/null
mkdir data

#
# Run the Docker deployment
#
docker compose up --detach
if [ $? -ne 0 ]; then
  echo '*** Problem encountered running the docker compose deployment'
  exit 1
fi

#
# Wait for the wordpress URL
#
WORDPRESS_URL='http://localhost/wp-admin/install.php'
echo 'Waiting for Wordpress to become available ...'
while [ "$(curl -k -s -o /dev/null -w ''%{http_code}'' "$WORDPRESS_URL")" != '200' ]; do
  sleep 2
done

#
# Open the system browser
#
case "$(uname -s)" in

  Darwin)
    PLATFORM='MACOS'
 	;;

  MINGW64*)
    PLATFORM='WINDOWS'
	;;

  Linux)
    PLATFORM='LINUX'
	;;
esac

if [ "$PLATFORM" == 'MACOS' ]; then

  open "$WORDPRESS_URL"

elif [ "$PLATFORM" == 'WINDOWS' ]; then

  start "$WORDPRESS_URL"

elif [ "$PLATFORM" == 'LINUX' ]; then

  xdg-open "$WORDPRESS_URL"

fi
