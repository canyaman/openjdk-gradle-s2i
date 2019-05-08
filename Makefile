IMAGE_NAME = openjdk-gradle-s2i
ENV_FILE = build.properties
DOCKER_ENV = env.properties

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	ENV_FILE="${ENV_FILE}" \
	DOCKER_ENV="${DOCKER_ENV}" \
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: install
install:
	oc login -u admin -p admin
	oc apply -f ./imagestreams/openjdk-redhat-s2i-imagestream.json
	oc apply -f ./imagestreams/openjdk-gradle-s2i-imagestream.json
	oc apply -f ./buildconfigs/openjdk-gradle-s2i-buildconfig.yaml
