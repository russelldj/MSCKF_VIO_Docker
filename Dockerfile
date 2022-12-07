#Download base image ubuntu 16.04
FROM mjenz/ros-kinetic-desktop-full:latest

# Suggestion taken from here: https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work
# Uses bash instead of sh
SHELL ["/bin/bash", "-c"]

# LABEL about the custom image
LABEL maintainer="davidrus@andrew.cmu.edu"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
running MSCKF_VIO SLAM system."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
# Install vim/screen as general utilities
RUN apt install git vim screen -y
# Install suitesparse
RUN apt-get install libsuitesparse-dev -y
# Install Ceres and deps for OpenVINS
RUN  apt-get install -y cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev libceres-dev
# Install tkinter for openvins matplotlib visualization
RUN apt-get install python-tk -y

# Begin setting the workspace up
RUN cd ~ && mkdir catkin_ws && cd catkin_ws && mkdir src && source /opt/ros/kinetic/setup.bash && catkin_make
# Clone MSCKF
RUN cd ~/catkin_ws/src && git clone https://github.com/russelldj/msckf_vio.git && cd ..
RUN cd ~/catkin_ws/src && git clone https://github.com/rpng/open_vins.git && cd ..
RUN cd ~/catkin_ws/src && git clone https://github.com/fyandun/ned_enu_tf.git && cd ..  
RUN cd ~/catkin_ws && source /opt/ros/kinetic/setup.bash && catkin_make --pkg msckf_vio --cmake-args -DCMAKE_BUILD_TYPE=Release && catkin_make --pkg ned_enu_tf
RUN cd ~/catkin_ws && source /opt/ros/kinetic/setup.bash && catkin_make -j 8
# Make tool RUN echo "alias src='source ~/catkin_ws/devel/setup.bash'" > ~/.bash_aliases # Make mountpoint RUN mkdir -p /root/data
