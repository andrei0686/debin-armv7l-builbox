# debin-armv7l-builbox
проект docker контейнера для отладки приложений под armv7l debian на системе x86

 ### Технология:
на сервере с docker запускается контейнер из образа debian под архитектуру armv7l.

контейнер работает в рэжиме эмуляции процессора через qemu-user-static

получается вы работается в системе с архитектурой armv7l которая зупащена на серевер с архитектурой x86.

по ssh подключаетесь к системе и отлаживаете и запускаете свои приложения под архитектуру armv7l.


## Как это использовать
в качестве примера была взята информация с https://www.stereolabs.com/docs/docker/building-arm-container-on-x86/

 ### Как получить образ сборки

 Образ предоставляет SSH-сервер через порт 22.

* Login `root`
* password `root`


#### собрать образ из dockerfile
для работы понадобится установить пакеты эмуляции процессоров qemu на сервере где запущен docker
```sh
  sudo apt-get install qemu binfmt-support qemu-user-static 
  docker run --rm --privileged multiarch/qemu-user-static --reset
```
затем получить репозиторий и построить образ 
```sh
git clone https://github.com/andrei0686/debin-armv7l-builbox
cd debin-armv7l-builbox/
docker build --rm -t debin-armv7l-builbox . 
 ```
 Для запуска контейнера сборки необходимо выполнить
 ```sh
 docker run -d -p 12345:22 --security-opt seccomp:unconfined debin-armv7l-builbox
 ```
 
 ### Как подключиться Visual Studio

В visual studio `Tools > Options > Cross Platform > Linux` выбрать credential

![Linux connect manager](https://msdnshared.blob.core.windows.net/media/2016/03/Connect-to-Linux-first-connection.png)

* Hostname: IP или hostname машыны docker где запущен контейнет   
* Port: порт для подключения который прокинут в контейнере докер на порт 22 ( `12345` в пример)
* Username: `root`
* Authentication type: `password`
* Password: `root`

## Extends

Вы можете создать свой образ в который включите дополнительные зависимости.

пример:

```Dockerfile
FROM 
/debin-armv7l-builbox

RUN apt-get update && \
    apt-get install -y libxml2-dev pkg-config libssl-dev libsasl2-dev automake autoconf libtool && \
    git clone https://github.com/mongodb/mongo-c-driver.git && \
    cd mongo-c-driver && \
    git checkout 1.3.5 && \
    ./autogen.sh && \
    make && make install
```
