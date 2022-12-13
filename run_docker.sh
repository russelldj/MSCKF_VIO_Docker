mkdir -p data/bags data/results
xhost +local:root
#docker run -v $(realpath data):/root/data -it msckf /bin/bash

docker run --rm -it -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v /home/eric/Desktop/SLAM/msckf_vio:/root/catkin_ws/src/msckf_vio/ \
    -v $(realpath data):/root/data msckf


