# debin-armv7l-builbox
проект docker контейнера для отладки приложений под armv7l debian на системе x86

## Как это использовать
 
 ### Как получить образ сборки

 Образ предоставляет SSH-сервер через порт 22.

* Login `root`
* password `root`

Получить контейнер из репозитория
```sh
docker pull andrei0686/debin-armv7l-builbox:latest
 ```
 
 Для запуска контейнера сборки необходимо выполнить
 ```sh
 docker run -d -p 12345:22 --security-opt seccomp:unconfined andrei0686/debin-armv7l-builbox
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
