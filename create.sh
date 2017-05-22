#!/bin/bash

if [ ${EUID:-${UID}} != 0 ]; then
    echo 'Not superuser.'
    exit
fi

# Start creating image

# Select base image
echo "[Step1] Select base image number from below images."
BASE_IMAGES=(`echo $(ls images/)`)
cnt=0
for image in ${BASE_IMAGES[@]}; do
  echo "  "${cnt}: ${image}
  let cnt++
done
echo -n "Base Image: "
read NUM
BASE_IMAGE=${BASE_IMAGES[${NUM}]}
echo

# New image name
echo "[Step2] Input new VM name."
echo -n "  Used names: "
LIST=$(virsh list --all | tail -n +3 | awk '{print $2}')
arr=(`echo $LIST`)
echo -n "["
for item in ${arr[@]}; do
  echo -n $item", "
done
echo "]"

echo -n "Image name: "
read IMAGE_NAME
cp base.xml ${IMAGE_NAME}.xml
sed -i -e "s/image-name/${IMAGE_NAME}/g" ${IMAGE_NAME}.xml
echo

# Memory size
echo "[Step3] Input memory size of new VM."
echo -n "Memory size [GB]: "
read MEMORY_SIZE
sed -i -e "s/memory-size/$((1024*1024*${MEMORY_SIZE}))/g" ${IMAGE_NAME}.xml
echo

# VNC Port
echo "[Step4]Input VNC port number of new VM."
echo -n "  Used Ports: ["
for item in ${arr[@]}; do
  echo -n $(virsh dumpxml $item | grep vnc | awk '{print $3}' | sed -e "s/port=//g" -e "s/'//g")", "
done
echo "]"
echo -n "VPC Port: "
read VNC_PORT
sed -i -e "s/vnc-port/${VNC_PORT}/g" ${IMAGE_NAME}.xml
echo

# Create base image from splite pieces.
echo "Creating VM..."
mkdir -p /opt/libvirt/images
cat images/${BASE_IMAGE}/image-piece.* > /opt/libvirt/images/${IMAGE_NAME}.qcow2

virsh define ${IMAGE_NAME}.xml
virsh start ${IMAGE_NAME}

sleep 10

MAC=$(virsh dumpxml ${IMAGE_NAME} | grep "mac address" | awk '{print $2}' | sed -e "s/address='//g" -e "s#'/>##g")

RES=`virsh net-dhcp-leases default | grep $MAC`
while :
do
  if [ "$RES" ]; then
    break
  fi
  sleep 1
  RES=`virsh net-dhcp-leases default | grep $MAC`
done
echo "Image creating is Successful. New VM Info is below:"
arr=($RES)
CREATE_DATE=${arr[0]}" "${arr[1]}
MAC_ADDR=${arr[2]}
IP_ADDR=${arr[4]}
HOST_NAME=${arr[5]}
echo
echo "  Create Date : "${CREATE_DATE}
echo "  MAC Address : "${MAC_ADDR}
echo "  IP Address  : "${IP_ADDR}
echo "  Host Name   : "${HOST_NAME}
echo
