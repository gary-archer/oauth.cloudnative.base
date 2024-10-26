#!/bin/bash

########################################################
# A script to deploy and expose Wordpress in the cluster
########################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Deploy the NGINX ingress controller
#
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the ingress controller'
  exit 1
fi

#
# Wait for NGINX
#
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

#
# Work around default developer setups not working
#
##kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

#
# Create a MySQL secret for credentials
#
kubectl delete secret mysql-passwords 2>/dev/null
kubectl create secret generic mysql-passwords \
  --from-literal=mysql-root-password='Password1' \
  --from-literal=mysql-password='Password1'
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating MySQL secrets'
  exit 1
fi

#
# Create the MySQL resources
#
kubectl delete -f mysql.yaml 2>/dev/null
kubectl apply  -f mysql.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the MySQL component'
  exit 1
fi

#
# Create the main Wordpress resources
#
kubectl delete -f wordpress.yaml 2>/dev/null
kubectl apply  -f wordpress.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered creating the Wordpress component'
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