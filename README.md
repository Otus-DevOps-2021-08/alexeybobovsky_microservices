# Практические работы по курсу **DevOps практики и инструменты** (alexeybobovsky_microservices)
## Содержание

12. [Docker. Образы, контейнеры, DockerHub.](#docker-2)
13. [Docker-образы. Микросервисы.](#docker-3)

## ДЗ 12. Docker. Образы, контейнеры, DockerHub.<a name="docker-2"></a>


### План работы
* Создание docker host.
* Создание своего образа.
* Работа с DockerHub.

### Практические задачи

#### Выполнения плана работ по сценарию в методичке
* Запуск VM с установленным Docker Engine при помощи Docker Machine.
* Написан Dockerfile и выполнена сборка образа с тестовым приложением.
* Сохранение образа на DockerHub.
* Развёртывание контейнера из образа на DockerHub.
* Задание со (*): На основе вывода команд **docker inspect** описано отличие контейнера от образа (в *dockermonolith/docker-1.log*)

### Useful things

Комманды
  ```
    docker ps                                                               //Список запущенных контейнеров
    docker ps -a                                                            //Список всех контейнеров
    docker images                                                           //Список сохранненных образов
    docker create                                                           //когда не нужно стартовать контейнер сразу
    docker start 4a6f32d31f7d                                               //запуск контейнера
    docker attach 4a6f32d31f7d                                              //подключение к консоли контейнера
    docker build -t reddit:latest .                                         //сборка образа с тэгом из Dockerfile в текущей директории
    docker run -i ... = docker create + docker start + docker attach        //
    docker run -it ubuntu:18.04 /bin/bash                                   //Старт контейнера из репы, старт TTY,  запуск bash переход в него (при выходе останавливается)
    docker run --name reddit -d --network=host reddit:latest                //Старт контейнера из локадьного image по тэгу
    docker run --name reddit -d -p 9292:9292 fmeat/otus-reddit:1.0          //Старт контейнера из репозитория по тэгу с открытым портом
    docker login                                                            //логина в репозиторий на терминале
    docker tag reddit:latest fmeat/otus-reddit:1.0                          //тэгирование образа
    docker push fmeat/otus-reddit:1.0                                       //Загрузка образа в репу
    docker logs reddit -f                                                   //Просмотр логов в контейнере
    docker diff reddit                                                      //Сравнение отличий контейнера от его образа
    docker exec 4a6f32d31f7d bash                                           //Запускает новый процесс внутри контейнера
    docker commit 4a6f32d31f7d alexeybobovsky/ubuntu-tmp-file               //Создает image из контейнера (Контейнер остается запущенным)
    docker inspect 4a6f32d31f7d                                             //подробная инфа об образе/контейнере - зависит от id
    docker stop 4a6f32d31f7d                                                //посылает SIGTERM, и через 10 секунд (настраивается) посылает SIGKILL
    docker kill 4a6f32d31f7d                                                //посылает SIGKILL - останавливает контейнер
    docker kill $(docker ps -q)                                             //останавливает все запущенные контейнеры
    docker system df                                                        //Отображает сколько дискового пространства занято образами, контейнерами и volume’ами
    docker rm $(docker ps -a -q)                                            //удалит все незапущенные контейнеры (с опцией -f также запущенные)
    docker rmi 09aca3d271ee                                                 //удаляет image, если от него не зависят запущенные контейнеры

  ```

Установка docker-mashine (depricated)
  ```
    docker-machine create \
    --driver generic \
    --generic-ip-address=51.250.10.185 \
    --generic-ssh-user yc-user \
    --generic-ssh-key ~/.ssh/appuser \
    docker-host
  ```

## ДЗ 13. Docker-образы. Микросервисы.<a name="docker-3"></a>


### План работы
* Разбить приложение на несколько компонентов
* Запустить микросервисное приложение
### Практические задачи

#### Выполнения плана работ по сценарию в методичке
* Освоить описание и сборку Docker-образы для сервисного приложения
* Освоить оптимизацию работы с Docker-образами
* Запуск и работа приложения на основе Docker-образов, оценка удобства запуска контейнеров при помощи **docker run**
* Ознакомление с **volume** в docker.

### Useful things

Комманды
  ```
    docker network create reddit                                            //Создание bridge-сети для приложения
    docker run -d --network=reddit \
        --network-alias=post_db --network-alias=comment_db mongo:latest     //Запуск контейнеров в сети и добавление им сетевых алиасов
    docker volume create reddit_db                                          //Создание Docker volume
    docker run -d -v reddit_db:/data/db mongo:latest                        //Подключение Docker volume к контейнеру
  ```
