FROM andrei0686/qemu_armv7:latest
MAINTAINER andrei

RUN uname -m
RUN apt-get update
RUN apt-get install -y openssh-server gdb gdbserver build-essential git zip rsync cmake
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i -E 's/#\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN cd /home/
RUN git clone https://github.com/catchorg/Catch2.git
RUN cd Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF
RUN cmake --build build/ --target install
RUN rm -R /home/Catch2
RUN apt-get clean

VOLUME /usr/src
WORKDIR /usr/src

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
