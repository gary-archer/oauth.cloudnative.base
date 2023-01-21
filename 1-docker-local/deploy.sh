#!/bin/bash

##################################################
# A basic Docker deployment of Wordpress and MySQL
##################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Run the Docker deployment
#
./teardown.sh
docker compose --project-name wordpress up --force-recreate --detach
if [ $? -ne 0 ]; then
  echo '*** Problem encountered running the docker compose deployment'
  exit 1
fi

#
# Wait for the wordpress URL
#
WORDPRESS_URL='http://wordpress.local/wp-admin/install.php'
echo 'Waiting for Wordpress to become available ...'
while [ "$(curl -k -s -o /dev/null -w ''%{http_code}'' "$WORDPRESS_URL")" != '200' ]; do
  sleep 2
done

#
# Open the system browser
#
case "$(uname -s)" in

  Darwin)
    PLATFORM="MACOS"
 	;;

  MINGW64*)
    PLATFORM="WINDOWS"
	;;

  Linux)
    PLATFORM="LINUX"
	;;
esac

if [ "$PLATFORM" == 'MACOS' ]; then

  open "$WORDPRESS_URL"

elif [ "$PLATFORM" == 'WINDOWS' ]; then

  start "$WORDPRESS_URL"

elif [ "$PLATFORM" == 'LINUX' ]; then

  xdg-open "$WORDPRESS_URL"

fi