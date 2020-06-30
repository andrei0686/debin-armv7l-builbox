FROM andrei0686/qemu_armv7:latest
MAINTAINER andrei

RUN echo "deb http://httpredir.debian.org/debian stretch main contrib non-free" > etc/apt/sources.list && \
echo "deb-src http://httpredir.debian.org/debian stretch main contrib non-free" >> etc/apt/sources.list && \
echo "deb http://httpredir.debian.org/debian stretch-backports main contrib non-free" >> etc/apt/sources.list && \
echo "deb-src http://httpredir.debian.org/debian stretch-backports main contrib non-free" >> etc/apt/sources.list && \
echo "Package: *" > etc/apt/preferences.d/backport && \
echo "Pin: release n=stretch-backports" >> etc/apt/preferences.d/backport && \
echo "Pin-Priority: 500" >> etc/apt/preferences.d/backport

RUN uname -m && \
 apt-get update && \
 apt-get install -y openssh-server gdb gdbserver build-essential git zip rsync libuv1 cmake-data cmake && \
 mkdir /var/run/sshd && \
 echo 'root:root' | chpasswd && \
 sed -i -E 's/#\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
 sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
 
RUN cd /home/ && \
  git clone https://github.com/catchorg/Catch2.git && \
  cd Catch2 && \
  cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
  cmake --build build/ --target install && \
  apt-get clean
RUN rm -Rfv /home/Catch2

VOLUME /root
WORKDIR /root

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
