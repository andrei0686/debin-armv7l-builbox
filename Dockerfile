FROM andrei0686/qemu_armv7:latest
MAINTAINER andrei

RUN uname -m && \
 apt-get update && \
 apt-get install -y openssh-server gdb gdbserver build-essential git zip rsync && \
 mkdir /var/run/sshd && \
 echo 'root:root' | chpasswd && \
 sed -i -E 's/#\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
 sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN cd /home/ && \
  git clone --branch v3.16.8 --single-branch https://github.com/Kitware/CMake.git && \
  cd CMake && \
  ./bootstrap --parallel=8 --no-system-libs --no-qt-gui -DCMAKE_USE_OPENSSL=OFF && make && make install && \
  rm -Rfv /home/CMake
RUN cd /home/ && \
  git clone https://github.com/catchorg/Catch2.git && \
  cd Catch2 && \
  cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
  cmake --build build/ --target install && \
  apt-get clean
RUN rm -Rfv /home/Catch2

VOLUME /usr/src
WORKDIR /usr/src

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
