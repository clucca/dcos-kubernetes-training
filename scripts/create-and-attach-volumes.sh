
name=$CLUSTER
region=$REGION
maws=$1

eval $(maws login ${maws})

aws --region=$region ec2 describe-instances |  jq --raw-output ".Reservations[].Instances[] | select((.Tags | length) > 0) | select(.Tags[].Value | test(\"$name-privateagent\")) | select(.State.Name | test(\"running\")) | [.InstanceId, .Placement.AvailabilityZone] | \"\(.[0]) \(.[1])\"" | while read instance zone; do
  volume=$(aws --region=$region ec2 create-volume --size=100  --availability-zone=$zone --tag-specifications="ResourceType=volume,Tags=[{Key=string,Value=$name}]" | jq --raw-output .VolumeId)
  sleep 10
  aws --region=$region ec2 attach-volume --device=/dev/xvdf --instance-id=$instance --volume-id=$volume
done
