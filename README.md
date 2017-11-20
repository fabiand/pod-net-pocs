How to connect qemu to pod networks:

Setup minikube, then:

```
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
