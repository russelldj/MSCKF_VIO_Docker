mkdir -p data/bags data/results
xhost +local:root
#docker run -v $(realpath data):/root/data -it msckf /bin/bash

docker run -it -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v $(realpath data):/root/data msckf


