FROM ubuntu:14.04

MAINTAINER Martial Maillot "martial.maillot@gmail.com"

ENV ANDROID_VERSION=24.4.1
ENV ANDROID_API_LEVEL=25
ENV ANDROID_BUILD_TOOLS_VERSION=25.0.0

# Install Java 8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install 32 bits lib for android + git/python/curl
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r$ANDROID_VERSION-linux.tgz && \
  tar xzf android-sdk.tgz && \
  rm -f android-sdk.tgz && \
  chown -R root.root android-sdk-linux && \
  chmod -R 777 /opt/android-sdk-linux

# Copy licenses
COPY licenses /opt/android-sdk-linux/licenses

RUN chmod +x /opt/tools/android-accept-licenses.sh
RUN ls -al /opt/tools/
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter platform-tools"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter android-$ANDROID_API_LEVEL"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter build-tools-$ANDROID_BUILD_TOOLS_VERSION"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter extra-android-m2repository"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter extra-android-support"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter extra-google-m2repository"
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --no-ui --all --filter extra-google-google_play_services"

# Cleaning
RUN apt-get clean

# Go to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
