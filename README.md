How to connect qemu to pod networks:

Setup minikube, then:

# All in one

```
$ k create \
    -f https://raw.githubusercontent.com/fabiand/pod-net-pocs/master/iscsi-demo-target.yaml \
    -f https://raw.githubusercontent.com/fabiand/pod-net-pocs/master/qemu-slirp.d/pod.yaml \
    -f https://raw.githubusercontent.com/fabiand/pod-net-pocs/master/qemu-proxy.d/pod.yaml \
    -f https://raw.githubusercontent.com/fabiand/pod-net-pocs/master/client.yaml

$ k get pods -w  # Until all pods are running

$ k logs client -f
```


## Or step by step

```
# Create the disk to boot from
$ k create -f iscsi-demo-target.yaml

$ k create -f qemu-slirp.d/pod.yaml
OR
$ k create -f qemu-proxy.d/pod.yaml
```

Then to check:

```
$ k create -f client.d/client.yaml
$ k logs client -f
```
