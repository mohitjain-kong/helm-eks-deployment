From DB Less to hybrd in EKS

Add CP and DP Certs 

Create a file called install_cp.sh
Create a file called create_secrets_cp.sh

Create a file called install_dp.sh
Create a file called create_secrets_dp.sh


2) Provision the kong namespace for the Control Plane:

kubectl create namespace kong-hybrid-cp

3) Provision the kong namespace for the Data Plane:

kubectl create namespace 


4) Setup the Control Plane:
    4.1) Save the Kong enterprise license file temporarily to disk and execute the following command:

         kubectl create secret generic kong-enterprise-license --from-file=license=./license -n kong-hybrid-cp

    4.2) Create a secret containing the password for the Super-Admin user which can be used to login into Kong Manager and the Admin API:

         kubectl create secret generic kong-enterprise-superuser-password -n kong-hybrid-cp --from-literal=password=password

    4.3) Create the secrets for Kong Manager and Kong Portal:

        kubectl create secret generic kong-session-conf --from-file=admin_gui_session_conf --from-file=portal_session_conf -n kong-hybrid-cp

    4.4) Create a secret containing the certificates for the Control Plane

        kubectl create secret tls kong-cluster-cert --cert=cluster.crt --key=cluster.key -n kong-hybrid-cp

    4.5) <<Optional>> Create a secret containing the CA certs for Kong Manager for HTTPS

        kubectl create secret tls kong-manager-cert --cert=tls.crt --key=tls.key -n kong-hybrid-cp

    4.6) Open the file kong-enterprise-on-kubernetes-no-ingress-hybrid-cp.yaml and change all the secrets where it says "change-me"

    4.7) Install the Control Plane within the kong-hybrid-cp namespace

        helm install kong-enterprise-control-plane-1 kong/kong -n kong-hybrid-cp --values ./kong-cp.yaml


5) Setup the Data Plane:

    5.1) Save the Kong enterprise license file temporarily to disk and execute the following command:

        kubectl create secret generic kong-enterprise-license --from-file=license=./license -n kong-hybrid-dp

    5.2) Create a secret containing the certificates for the Data Plane

        kubectl create secret tls kong-cluster-cert --cert=cluster.crt --key=cluster.key -n kong-hybrid-dp

    5.3 <<Optional>> Create a secret containing the CA certs for Kong Proxy for HTTPS

        kubectl create secret tls kong-proxy-cert --cert=cert.pem --key=privkey.pem -n kong-hybrid-dp

    5.4) Open the file kong-enterprise-on-kubernetes-no-ingress-hybrid-dp.yaml and set the variables KONG_CLUSTER_CONTROL_PLANE and KONG_CLUSTER_TELEMETRY_ENDPOINT. An example configuration is provided within that file

    5.5) Install the Data Plane within the kong-hybrid-dp namespace

        helm install kong-enterprise-data-plane-1 kong/kong -n kong-hybrid-dp --values ./kong-dp.yaml


6) Verify setup:

GET  http://localhost:8001/clustering/status  should return something like this:

{
    "f83dc330-d794-4340-8562-56046099995b": {
        "ip": "172.17.0.8",
        "config_hash": "d172b4f06575b8dddc92ac1fee449785",
        "ttl": 1199493,
        "last_seen": 1608252449,
        "hostname": "dataplane-kong-enterprise-5cb7787c8-lb952"
    },
    "194dd531-aa05-48f3-a1a9-cdc36d5fc018": {
        "ip": "172.17.0.6",
        "config_hash": "d172b4f06575b8dddc92ac1fee449785",
        "ttl": 1199383,
        "last_seen": 1608252339,
        "hostname": "dataplane-kong-enterprise-bb457945c-pplnv"
    }
}