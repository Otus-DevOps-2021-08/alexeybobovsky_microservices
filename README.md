# Практические работы по курсу **DevOps практики и инструменты** (alexeybobovsky_microservices)

*Репозиторий с заданиями по инфраструктуре (alexeybobovsky_infra) находится [тут](https://github.com/Otus-DevOps-2021-08/alexeybobovsky_infra)*

## Содержание

12. [Docker. Образы, контейнеры, DockerHub.](#docker-2)
13. [Docker. Образы. Микросервисы.](#docker-3)
14. [Docker. Сети. docker-compose.](#docker-4)
16. [Создание и запуск системы мониторинга Prometheus.](#monitoring-1)
17. [Логирование приложений и распределенная трассировка.](#logging-1)
18. [Установка и настройка Kubernetes (kubeadm).](#kubernetes-1)

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
    eval $(docker-machine env docker-host)                                  //

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

## ДЗ 14. Docker: сети. docker-compose.<a name="docker-4"></a>

### План работы
* Работа с сетями в Docker
* Использование docker-compose
### Практические задачи

#### Выполнение плана работ по сценарию в методичке
* Освоены особенности работы с сетями в Docker
* Выполнена сборка и запуск приложений с помощью docker-compose
* Описана параметризация базового имени проекта

Базовое имя проекта можно задать через ключ ```-p``` в docker-compose CLI либо задать через переменную ```COMPOSE_PROJECT_NAME``` в ```.env``` файле. По умолчанию используется имя рабочей директории.

### Useful things

Комманды
  ```
    docker network connect front_net post                                   //Подключение контейнера post к сети front_net
    docker-compose up -d                                                    //Сборка и запуск приложений с помощью docker-compose
  ```

## ДЗ 16. Создание и запуск системы мониторинга Prometheus.<a name="monitoring-1"></a>

### План работы
* Prometheus: запуск, конфигурация, знакомство с Web UI
* Мониторинг состояния микросервисов
* Сбор метрик хоста с использованием экспортера

### Практические задачи

#### Выполнение плана работ по сценарию в методичке
* Созданы файл конфигурации, образ,  стартован контейнер с Prometheus и микросервисами. Проведены базовые манипуляции с Web UI Prometheus.
* Сконфигурирован и создан образ експортера, стартован с Prometheus и микросервисами,  проведён стресс тест на хосте и зафиксированы соответствующие изменения метрик
* Полученные образы запушены в докерхаб:
  - [Образ Prometheus](https://hub.docker.com/repository/docker/fmeat/prometheus)
  - [Образ ui](https://hub.docker.com/repository/docker/fmeat/ui)
  - [Образ comment](https://hub.docker.com/repository/docker/fmeat/comment)
  - [Образ post](https://hub.docker.com/repository/docker/fmeat/post)

### Useful things

Комманды
  ```
    docker-compose stop post                                   //Остановка отдельного контейнера посредством docker-compose
    docker-compose start post                                  //Старт отдельного контейнера посредством docker-compose
    docker-compose down                                        //Остановка и удаление всех поднятых ранее с помощью  docker-compose up -d контейнеров (в и.ч. и network)
    yes > /dev/null                                            //старт стресс теста CPU

  ```

## ДЗ 17. Логирование приложений и распределенная трассировка.<a name="logging-1"></a>

### План работы
* Подготовка окружения.
* Логирование Docker-контейнеров.
* Сбор неструктурированных логов.
* Визуализация логов.
* Сбор структурированных логов.
* Распределенный трейсинг.

### Практические задачи

#### Выполнение плана работ по сценарию в методичке
* Созданы образы, compose-файл для системы логирования на базе EFK (Fluentd) стека.
* Сбор неструктурированных логов.
* Визуализация логов.
* Сбор структурированных логов.
* Распределенный трейсинг.

### Useful things

Комманды
  ```
    docker-compose -f composeFile.yml up -d         //Старт docker-compose проекта с указанием специфичного файла (по умолчанию docker-compose.yml)
    docker-compose -f composeFile.yml down          //Остановка docker-compose проекта с указанием специфичного файла
    docker-compose stop ui && \                     //Остановка
    docker-compose rm ui && docker-compose up -d    //удаление, создание и старт нового отдельного контейнера из проекта docker-compose

  ```
## ДЗ 18. Установка и настройка Kubernetes (kubeadm).<a name="kubernetes-1"></a>

### План работы
* Разобрать на практике все компоненты Kubernetes, развернуть их вручную используя kubeadm.
* Ознакомиться с описанием основных примитивов приложенияи и его дальнейшим запуском в Kubernetes.
* Задание ** Описать установку кластера k8s с помощью terraform и ansible.

### Практические задачи

#### Выполнение плана работ по сценарию в методичке
* Развёрнут кластер Kubernetes с использованием kubeadm.
* Настроен сетевой плагин CALICO.
* Зааплаены деплойменты.
* Описана установка кластера k8s с помощью terraform и ansible.

### Useful things

Комманды
  ```
    kubectl get nodes                                       //отображение списка нод кластера
    kubectl describe node {node-name}                       //подробная информация о ноде
    kubectl apply -f {filename}                             //установка манифеста
    kubeadm token list
    kubeadm join --token={token} \
        --discovery-token-unsafe-skip-ca-verification \
          {cluster api ip}:6443                             //добавление ноды в кластер
    kubectl get pods --all-namespaces                       //отображение всех ПОД-ов кластера

  ```
