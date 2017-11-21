# Connecting VMs to the Kubernetes network, a few POVs

A few POCs of how to allow inbound traffic to VMs, with different degrees
of portability.

Preparations:

1. Setup minikube
2. Deploy demo image to boot: 
   `$ k create -f iscsi-demo-target.yaml`
3. Choose and deploy a method below
4. Optional: Run the client to check if it's working properly:
   `$ k create -f client.d` then `$ k logs client -f`

## Approaches

### SLIRP

With SLIRP qemu emulatest the complete VM network in a process and allows
inbound traffic by binding the qemu process to certain ports on the host.
If a client connects to these ports, then the traffic is forwarded to the
guest.
This is very much in line with how Kubernetes assumes networking of processes
to work.

Outbound VM traffic is NAT-ed by qemu.

Try it out with:

```bash
$ k create -f qemu-slirp.d
$ k logs -f qemu-slirp
```

### Proxy

Kubernetes assumes that processes are opening ports on the pod's network
interface. This approach achieves this by using a proxy, which is listening
on one or more ports, and forwards any request to a VM bound to a private IP
within the pod (VM has an IP and is connected to a bridge via a TAP).

Outbound VM traffic is NAT-ed by iptables.

```bash
$ k create -f qemu-proxy.d
$ k logs -f qemu-proxy
```

### DNAT

Similar to the _Proxy_ approach, but the inbound traffic is not relayed through
a proxy, but rather `iptables` is used to redirect any incoming request to any
port to the VM with the private ip.
This is less portable, because this approach breaks the Kubernetes assumption
that a process is bound to a port. This assumption might not be made by
Kubernetes, but maybe by add-ons, CNI, or side-car containers.

Outbound VM traffic is NAT-ed by iptables.

```bash
$ k create -f qemu-dnat.d
$ k logs -f qemu-dnat
```

## Checking

```
$ k create -f client.d/client.yaml
$ k logs client -f
```
