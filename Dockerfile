FROM ubuntu:16.04
MAINTAINER Antonio Sidoti <antosidoti@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive MBDYN_VERSION=1.7.1

# Update repositories
RUN apt-get -y update

# Install required packages
RUN apt-get install -y build-essential libmetis-dev libumfpack5.7.1 \
                       libsuitesparse-dev libarpack++2-dev libarpack2-dev \
                       libopenmpi-dev libginac-dev curl libtool gcc

# Download MBDyn
RUN curl https://www.mbdyn.org/userfiles/downloads/mbdyn-$MBDYN_VERSION.tar.gz \
         -o /tmp/mbdyn.tar.gz

# Extracting sources
RUN mkdir /tmp/mbdyn-src && \
    tar xf /tmp/mbdyn.tar.gz --strip 1 -C /tmp/mbdyn-src && \
    cd /tmp/mbdyn-src
# Configuring and compiling with the required options
RUN ./tmp/mbdyn-src/configure --enable-runtime-loading --with-module="cont-contact" LDFLAGS=-rdynamic
# Compiling and deleting source
RUN  make
RUN  make install && \
     cd / && rm -rf /tmp/mbdyn-src

# Configuring PATH variable so that mbdyn is recognized
ENV PATH="/usr/local/mbdyn/bin:${PATH}" 

# Define working directory.
WORKDIR /home
