#!/bin/bash

if [ ${EUID:-${UID}} != 0 ]; then
    echo 'Not superuser.'
    exit
fi

echo
IMAGES=(`virsh list --all | tail -n +3 | awk '{print $2}' | grep -v '^\s*$'`)
cnt=0
for image in ${IMAGES[@]}; do
  echo "  "${cnt}: ${image}
  let cnt++
done
echo
echo -n "Delete image: "
read NUM
IMAGE=${IMAGES[${NUM}]}

echo "Deleting VM..."
virsh destroy ${IMAGE}

virsh undefine ${IMAGE}

sed -i '/'${IMAGE}'/d' /var/lib/libvirt/dnsmasq/default.addnhosts
sed -i '/'${IMAGE}'/d' /etc/hosts

rm ${IMAGES[${NUM}]}.xml

echo "Image Deleting is Successful."
