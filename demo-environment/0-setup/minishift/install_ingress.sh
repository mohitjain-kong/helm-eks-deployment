#!/bin/bash
mkdir apim.eu
cd apim.eu
curl -o apim.keys.tgz -u kong:KongRul3z!  https://www.apim.eu/download/apim.keys.tgz
tar xzf apim.keys.tgz
oc create secret tls apim-secret --key ./privkey.pem --cert ./fullchain.pem
cd ..
rm -R apim.eu

echo -e "\n*** Lowering security settings (temporary workaround)"
oc login -u system:admin
oc adm policy add-scc-to-user anyuid system:serviceaccount:kong-ingress-controller:default
oc login -u developer

oc create -f ingress/postgres-ingress.yaml
oc --as system:admin create --validate=false -f ingress/kong_ingress_controller.yaml
oc create -f ingress/kong_ingress_rule.yaml

echo -e "*** Ingress controller created"
echo -e " Gateway-Proxy: https://os-proxy.apim.eu"
echo -e " Gateway-Admin: https://os-admin.apim.eu"
echo -e " Ingress-Admin: https://os-ingress.apim.eu\n"
echo -e "!!! You must have the following entry in your /etc/hosts:"
echo  " $(minishift ip) os-proxy.apim.eu os-admin.apim.eu os-ingress.apim.eu"
