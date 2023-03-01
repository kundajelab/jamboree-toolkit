##instructions here: 
##https://zero-to-jupyterhub.readthedocs.io/en/stable/index.html

gcloud auth login
gcloud auth application-default login
gcloud config set project mit-neurogen-spring22

gcloud container clusters create \
  --machine-type n1-standard-4 \
  --num-nodes 2 \
  --zone us-central1-a \
  --disk-size=50Gi \
  --cluster-version 1.20.15-gke.1000 \
  kbe-mit-neurogen-2022

kubectl create clusterrolebinding cluster-admin-binding \
	--clusterrole=cluster-admin \
	--user=spineda@mit.edu

gcloud beta container node-pools create user-pool \
       --machine-type n1-standard-8 \
       --num-nodes 1 \
       --enable-autoscaling \
       --min-nodes=0 \
       --max-nodes=20 \
       --node-labels hub.jupyter.org/node-purpose=user \
       --node-taints hub.jupyter.org_dedicated=user:NoSchedule \
       --zone us-central1-a \
       --disk-size=50Gi \
       --cluster kbe-mit-neurogen-2022

## Install jupyterhub
openssl rand -hex 32
## add secretToken to config.yaml
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

#create namespace
kubectl create -f namespace_jhub.yaml
kubectl get namespace

#add data volume
#note: first manually create a disk for data store, which is reference in data_pv.yaml
kubectl --namespace jhub apply -f data_pv.yaml 
kubectl --namespace jhub apply -f data_pvc.yaml
kubectl --namespace jhub get pvc

helm upgrade --install --cleanup-on-fail --namespace jhub  --version 1.2.0 --values config.yaml --set global.safeToShowValues=true jhub jupyterhub/jupyterhub --timeout 30m


##Your release is named jhub and installed into the namespace jhub.
##You can find if the hub and proxy is ready by doing:
## kubectl --namespace=jhub get pod
## and watching for both those pods to be in status 'Ready'.
## You can find the public IP of the JupyterHub by doing:
## kubectl --namespace=jhub get svc proxy-public
## It might take a few minutes for it to appear!
#kubectl config set-context $(kubectl config current-context) --namespace ${NAMESPACE:-jhub}
