cd $(dirname $0)

export SERVICEPATH=infra/monitoring/dcos-monitoring
export SERVICEACCOUNT=$(echo ${SERVICEPATH} | sed 's/\//-/g')
export ROLE=$(echo ${SERVICEPATH} | sed 's/\//__/g')-role

./create-service-account.sh
./grant-permissions.sh

dcos package install beta-dcos-monitoring --yes --options=options-dcos-monitoring.json
