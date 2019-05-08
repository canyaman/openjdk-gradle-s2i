# openjdk-gradle-s2i
Gradle S2I Builder for OpenShift, based on the standard redhat-openjdk18-openshift image

sha256:bd894dfc85b85d604fa464d33d22e39a4eeb9d03863169eb7aa527cdfa80d44b

docker pull canyaman/openjdk-gradle-s2i

docker build -t openjdk-gradle-s2i-candidate . IMAGE_NAME=openjdk-gradle-s2i-candidate test/run

## Testing
Update aws secret and password
```console
make test
```