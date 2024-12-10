FROM debian


RUN apt-get update && apt-get install -y git \
  clang \
  curl \
  libc++-dev \
  libc++abi-dev \
  build-essential \
  autoconf \
  automake \
  libtool \
  libusb-1.0-0-dev \
  libavahi-client-dev \
  libc6-dev \
  libimobiledevice-utils libimobiledevice-dev \
  && apt-get clean

# Clone, build, and install libgeneral
RUN git clone https://github.com/tihmstar/libgeneral && \
  cd libgeneral && \
  ./autogen.sh --prefix=/usr/local --enable-debug && \
  make && \
  make install

RUN curl https://github.com/libimobiledevice/libplist/releases/download/2.6.0/libplist-2.6.0.tar.bz2 -L -o libplist-2.6.0.tar.bz2 && \
  tar -xvf libplist-2.6.0.tar.bz2 && \
  cd libplist-2.6.0 && \
  ./configure --prefix=/usr/local --enable-debug && \
  make && \
  make install

# Clone, build, and install usbmuxd2
RUN git clone https://github.com/tihmstar/usbmuxd2 && \
  cd usbmuxd2 && \
  LDFLAGS="-latomic" ./autogen.sh --prefix=/usr/local --enable-debug && \
  ./configure CC=clang CXX=clang++ && \
  make && \
  make install


# Set the default command to bash
CMD ["bash"]
