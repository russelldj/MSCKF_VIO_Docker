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
# Install vim as a general utility
RUN apt install git vim -y
# Install suitesparse
RUN apt-get install libsuitesparse-dev -y

# Begin setting the workspace up
RUN cd ~ && mkdir catkin_ws && cd catkin_ws && mkdir src && source /opt/ros/kinetic/setup.bash && catkin_make
# Clone MSCKF
RUN cd ~/catkin_ws/src && git clone https://github.com/russelldj/msckf_vio.git && cd ..
# Build it
RUN cd ~/catkin_ws && source /opt/ros/kinetic/setup.bash && catkin_make --pkg msckf_vio --cmake-args -DCMAKE_BUILD_TYPE=Release
# Make mountpoint
RUN mkdir -p /root/data

# VNC visualization
RUN apt-get update && apt-get install -y \
  # Install vnc, xvfb for VNC configuration, fluxbox for VNC window managment
  x11vnc \
  xvfb \
  fluxbox

RUN  mkdir ~/.vnc \
  # Start the VNC server
  && echo '# VNC setup' >> /root/.bashrc \
  && echo "export DISPLAY=:20" >> ~/.bashrc \
  # Always try to start windows management in background to be ready for VNC
  && echo "( fluxbox > /dev/null 2>&1 & )" >> ~/.bashrc
  # # Clean up unnecessary output files
  # && echo "rm -f /root/CRATER_GRADER/cg_ws/nohup.out" >> ~/.bashrc

COPY msckf_entrypoint.sh /
RUN chmod +x /msckf_entrypoint.sh
WORKDIR /root/
ENTRYPOINT ["/msckf_entrypoint.sh"]
CMD ["bash"]
