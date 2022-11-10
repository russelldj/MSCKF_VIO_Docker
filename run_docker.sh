mkdir -p data/bags data/results
xhost +local:root
#docker run -v $(realpath data):/root/data -it msckf /bin/bash

docker run -p 5900:5900 -it -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v /Users/alexpletta/SLAM/Project/MSCKF_VIO_Docker/data:/root/data msckf


