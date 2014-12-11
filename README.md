#freehub

**BikeBike Docker Container Image for freehub**

Freehub is a member and shop visit [application](https://github.com/asalant/freehub/wiki) implemented in Rails by the [San Francisco Bike Kitchen](http://bikekitchen.org/).

##Pull the repository

```
docker pull bikebike/bikebike
```


##Run the docker container

Publish the container's port to the host:

>format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort


```
docker run -d -p 3000:3000 --name="freehub" bikebike/freehub
```

##Password

Password is *test* for **greeter**, **sfbk**, **mechanic**, **scbc**, **cbi**, **admin**.

##How to test/develop inside the running container process 

This method uses [nsenter](http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/).  Check out [jpetazzo/nsenter](https://github.com/jpetazzo/nsenter) on GitHub. 

```
sudo PID=$(docker inspect --format {{.State.Pid}} <container_name_or_ID>)
sudo nsenter --target $PID --mount --uts --ipc --net --pid
```
