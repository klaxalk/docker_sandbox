FROM ros:noetic

RUN apt-get -y update && apt-get -y install sudo

# fixes prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y install keyboard-configuration

# INSTALL the MRS UAV System

RUN sudo apt-get -y install software-properties-common git curl bash

RUN curl https://ctu-mrs.github.io/ppa-stable/add_ppa.sh | bash

RUN sudo apt-get -y install ros-noetic-desktop

RUN sudo apt-get -y install ros-noetic-mrs-uav-system-full

CMD ["bash"]
