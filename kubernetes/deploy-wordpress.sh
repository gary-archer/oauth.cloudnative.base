#!/bin/bash

#####################################
# Deploy application level components
#####################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create a MySQL secret for passwords
#
kubectl -n wordpress create secret generic mysql-passwords \
  --from-literal=mysql-root-password='Password1' \
  --from-literal=mysql-replication-password='Password1' \
  --from-literal=mysql-password='Password1'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating MySQL secrets'
  exit 1
fi

#
# Create the MySQL resources
#
kubectl -n wordpress apply  -f mysql.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL component'
  exit 1
fi

#
# Create the main Wordpress resources
#
kubectl -n wordpress apply  -f wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
  exit 1
fi

#
# Wait for the wordpress URL
#
echo 'Waiting for Wordpress to become available ...'
WORDPRESS_URL="http://$WORDPRESS_HOST_NAME/wp-admin/install.php"
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