# Задание 3 (Первые шаги с Ansible)

Vagrantfile разворачивает виртуальную машину.

Далее на этой виртуальной машине происходит развёртывание nginx при помощи Ansibl.

(Ansibl должен быть предванительно установлен на хосте)

Nginx слушает на порту 8080. Этот порт также пробрасывается на хост.

Для развёртывания виртуальной машины используйте команду:

```
$ vagrant up
```

Для проверки работы на хосте запустите команду:

```
$ curl http://localhost:8080
```
или откройте в браузере http://localhost:8080