#!/bin/sh
#Change project id and namespace here
#!/bin/sh
# $1 - gcpprojectid
# $2 - namespace
# $3 - imagename
# $4 - gcpcluster
if [[ "$4" == "" ]]; then
  echo "usage: gcpprojectid namespace imagename gcpcluster"
  exit 0;
fi
projectid=$1
namespace=$2
imagename=$3
gkecluster=$4
zone=asia-east1-a #optional parameter
#replacing wth project id

sed -i "s/projectid/$projectid/g" deployment.yml
sed -i "s/{imagename}/$imagename/g" deployment.yml
sleep 5
echo "Builiding application with docker"
docker build --tag  gcr.io/$projectid/$imagename .
sleep 5
docker push gcr.io/$projectid/$imagename
# switching to training cluster
gcloud container clusters  get-credentials $gkecluster --project $projectid --zone $zone
sleep 5
kubectl apply -f deployment.yml -n $namespace
sleep 5
kubectl apply -f service.yml -n $namespace
sleep 5