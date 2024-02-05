##############################################################################
##                                 Base Image                               ##
##############################################################################
# ARG ROS_DISTRO=humble
# ARG ROS_PKG=desktop-full-jammy
# FROM osrf/ros:humble-desktop-full-jammy

FROM nvcr.io/nvidia/pytorch:24.01-py3

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

##############################################################################
##                                 Global Dependecies                       ##
##############################################################################
#POSIX standards-compliant default locale. Only strict ASCII characters are valid, extended to allow the basic use of UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV LC_ALL=C

RUN apt-get update && apt-get install --no-install-recommends -y \
    dirmngr gnupg2 lsb-release can-utils iproute2\
    apt-utils bash nano aptitude util-linux \
    htop git tmux sudo wget gedit bsdmainutils && \
    rm -rf /var/lib/apt/lists/*


# RUN apt-get update && apt-get install --no-install-recommends -y \
#     pip \
#     build-essential \
#     cmake \
#     libgtk2.0-dev \
#     pkg-config \
#     libavcodec-dev \
#     libavformat-dev \
#     libswscale-dev \
#     python3-dev \
#     python3-numpy \
#     libtbb2 \
#     libtbb-dev \
#     libjpeg-dev \
#     libpng-dev \
#     libtiff-dev \
#     # libdc1394-22-dev \
#     libflann-dev \
#     libboost-all-dev \
#     libqhull-dev \
#     libusb-dev \
#     libgtest-dev \
#     freeglut3-dev \
#     libxmu-dev \
#     libxi-dev \
#     libusb-1.0-0-dev \
#     graphviz \
#     mono-complete \
#     # qt-sdk \
#     openjdk-11-jdk \
#     openjdk-11-jre

##############################################################################
##                                 Create User                              ##
##############################################################################
ARG USER=robot
ARG PASSWORD=robot
ARG UID=1000
ARG GID=1000
ARG DOMAIN_ID=8
ARG VIDEO_GID=44
ENV ROS_DOMAIN_ID=${DOMAIN_ID}
ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}
RUN groupadd -g "$GID" "$USER"  && \
    useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
    groupadd realtime && \
    groupmod -g ${VIDEO_GID} video && \
    usermod -aG video "$USER" && \
    usermod -aG dialout "$USER" && \
    usermod -aG realtime "$USER" && \
    echo "$USER:$PASSWORD" | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "export ROS_DOMAIN_ID=${DOMAIN_ID}" >> /etc/bash.bashrc

USER $USER
RUN mkdir -p /home/$USER/ros2_ws/src

##############################################################################
##                      Data Generation Dependecies                         ##
##############################################################################

##############################################################################
##                                 Build ROS and run                        ##
##############################################################################
WORKDIR /home/$USER/ros2_ws

CMD /bin/bash

