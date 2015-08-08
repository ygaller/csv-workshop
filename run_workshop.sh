#/bin/bash

if [ $# -eq 0 ]
  then
    echo "Please enter the container name"
    exit
fi

sudo docker run -ti --name $1 csvworkshop /bin/bash
