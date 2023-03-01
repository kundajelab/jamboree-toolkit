## Distributing data

- create a data disk in GCP project 
- populate the disk with data by attaching it to a gcp vm 
- create a pv and a pvc in kubernetes (this is done with commands in create_kubernetes_cluster.sh): 
```
kubectl --namespace jhub apply -f data_pv.yaml
kubectl --namespace jhub apply -f data_pvc.yaml
kubectl --namespace jhub get pvc
```

All users will have read access to the data disk:

https://console.cloud.google.com/compute/disksDetail/zones/us-central1-a/disks/neurogen-data-pv-persistentdisk?authuser=3&cloudshell=true&project=mit-neurogen-spring22

To put data on the disk, make sure the "in use by" field at the link above is blank. If it's not, you can run this command to dettach the disk (see more details in notes.txt file in setup_2022 folder of this repo):

```
#detaching:
gcloud compute instances list #gives the pool name that disk is attached to
gcloud compute instances detach-disk gke-kbe-mit-neurogen-2022-user-pool-6a6c839c-5xqm  --disk neurogen-data-pv-presistentdisk
```
Then attach the disk in write mode to https://console.cloud.google.com/compute/instancesDetail/zones/us-central1-a/instances/instance-1?authuser=3&cloudshell=true&project=mit-neurogen-spring22, place data, and dettach again: 
```
gcloud compute instances detach-disk instance-1  --disk neurogen-data-pv-persistentdisk
```


## Setup kubernetes cluster 

logging in & setting the default project
```
gcloud auth login
gcloud auth application-default login
gcloud config set project [your-gcp-project-name]
```

Creates kubernete cluster, launching a node pool, download jupyterhub helm chart, and create deployment
```
create_kubernetes_cluster.sh  
```

## Updating the docker image after deployment

If you want to make updates to the docker image used, see `dockerfiles/Dockerfile`
Once you have updated/pushed this docker image, update the docker path and tag in config.yaml.

After you have updated the docker image and the config.yaml file, deploy the update to kubernets by running: 
```
./redeploy.sh
```

