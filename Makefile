DOCKER_USERNAME ?= narutosimaha
APPLICATION_NAME ?= lec-chatserver
 
build:
	docker build -t ${DOCKER_USERNAME}/${APPLICATION_NAME} .