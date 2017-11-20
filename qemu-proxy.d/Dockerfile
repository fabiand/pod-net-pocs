FROM kubevirt/libvirt-kubevirt:v0.0.2

RUN dnf install -y haproxy && dnf clean all

ADD run.sh /

CMD /run.sh
