IMAGES=$(patsubst %.d,%,$(wildcard *.d))

build: $(patsubst %,docker-build-%,$(IMAGES))
push: $(patsubst %,docker-push-%,$(IMAGES))

docker-build-%: %.d/Dockerfile
	sudo docker build -t docker.io/fabiand/$*:latest $*.d

docker-push-%:
	sudo docker push docker.io/fabiand/$*:latest

deploy:
	kubectl create -f

.PHONY: build
