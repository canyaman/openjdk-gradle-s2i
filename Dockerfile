FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

MAINTAINER Can Yaman <can@yaman.me>

ENV GRADLE_VERSION 5.4.1
ENV GRADLE_BIN_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_USER_HOME /opt/gradle

# Labels
LABEL name="openjdk18-gradle-openshift" \
      version="1.2" \
      architecture="x86_64"  \
      description="Source To Image (S2I) image for Red Hat OpenShift providing Gradle and OpenJDK 1.8" \
      summary="Source To Image (S2I) image for Red Hat OpenShift providing Gradle and OpenJDK 1.8" \
      com.redhat.deployments-dir="/deployment" \
      io.k8s.description="Platform for building and running plain Java/Kotlin applications (fat-jar and flat classpath) with Gradle" \
      io.k8s.display-name="Java Gradle S2I" \
      io.openshift.tags="builder,java,java8,gradle" \
      io.openshift.s2i.scripts-url="image:///opt/s2i" \
      io.openshift.s2i.destination="/tmp" \
      io.openshift.s2i.exclude="" \
      io.fabric8.s2i.version.gradle="${GRADLE_VERSION}"

USER root

# Install Gradle from distribution
RUN curl -L -o /tmp/gradle.zip --retry 5 ${GRADLE_BIN_URL} && \
    unzip -d /opt/gradle /tmp/gradle.zip && \
    rm /tmp/gradle.zip && \
	for f in /opt/gradle/*; do mv $f /opt/gradle/${GRADLE_VERSION}; done && \
	ln -sf /opt/gradle/${GRADLE_VERSION}/bin/gradle /usr/local/bin/gradle

COPY scripts/ /opt/s2i/

COPY gradle/*.gradle /opt/gradle/${GRADLE_VERSION}/init.d/

COPY gradle/*.properties ${GRADLE_USER_HOME}/

RUN chgrp -R 0 /opt/gradle && \
    chgrp -R 0 /opt/s2i && \
    chmod -R g=u /opt/gradle && \
    chmod -R g=u /opt/s2i
    

USER 185