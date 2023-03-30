DOCKER_USERNAME ?= narutosimaha
APPLICATION_NAME ?= lec-chatserver
 
build:
	docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} .