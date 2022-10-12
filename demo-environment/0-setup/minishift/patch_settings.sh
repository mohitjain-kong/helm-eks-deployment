#!/bin/bash
echo -e "\n*** Patching the url settings for Manager and portal"
. ../../1-environment/minishift.sh > /dev/null
. ../../1-environment/shared.sh > /dev/null
cp kong_patch_settings.yaml.template kong_patch_settings.yaml
sed -i -e "s/admin_gui_url/http\:\/\/$MANAGER_HOST\:$MANAGER_PORT/g" kong_patch_settings.yaml
sed -i -e "s/portal_gui_host/$ADMIN_HOST\:$PORTAL_PORT/g" kong_patch_settings.yaml
sed -i -e "s/portal_api_url/http\:\/\/$PORTAL_ADMIN_HOST\:$PORTAL_ADMIN_PORT/g" kong_patch_settings.yaml
sed -i -e "s/admin_api_url/http\:\/\/$ADMIN_HOST\:$ADMIN_PORT/g" kong_patch_settings.yaml

oc apply -f kong_patch_settings.yaml

rm kong_patch_settings.yaml
rm kong_patch_settings.yaml-e
