#!/bin/bash

if [ ${EUID:-${UID}} != 0 ]; then
    echo 'Not superuser.'
    exit
fi

# Start creating image

# Image name
echo -n "Used names: "
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

# Memory size
echo -n "Memory size [GB]: "
read MEMORY_SIZE
sed -i -e "s/memory-size/$((1024*1024*${MEMORY_SIZE}))/g" ${IMAGE_NAME}.xml

# VNC Port
echo -n "Used Ports: ["
for item in ${arr[@]}; do
  echo -n $(virsh dumpxml $item | grep vnc | awk '{print $3}' | sed -e "s/port=//g" -e "s/'//g")", "
done
echo "]"
echo -n "VPC Port: "
read VNC_PORT
sed -i -e "s/vnc-port/${VNC_PORT}/g" ${IMAGE_NAME}.xml

# Create base image from splite pieces.
echo "Creating VM..."
mkdir -p /opt/libvirt/images
cat image/image-piece.* > /opt/libvirt/images/${IMAGE_NAME}.qcow2

virsh define ${IMAGE_NAME}.xml
virsh start ${IMAGE_NAME}

sleep 10

MAC=$(virsh dumpxml test | grep "mac address" | awk '{print $2}' | sed -e "s/address='//g" -e "s#'/>##g")

echo "Image creating is Successful."
echo "VM Info"
virsh net-dhcp-leases default | grep $MAC
