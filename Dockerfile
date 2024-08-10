FROM library/debian:stable-slim

ARG CONCORD_VERSION=latest
ENV CONCORD_VERSION=${CONCORD_VERSION}
ENV CONCORD_DOCKER_DEFAULT_USER=1456
ENV RUNNER_ARGS=""

LABEL maintainer="ibodrov@gmail.com"`

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jre-headless && \
    apt-get clean && \
    groupadd -g ${CONCORD_DOCKER_DEFAULT_USER} concord && \
    useradd --no-log-init -u ${CONCORD_DOCKER_DEFAULT_USER} -g concord -m -s /sbin/nologin concord

COPY --chown=concord:concord target/deps/ /home/concord/.m2/repository

USER concord
CMD ["sh", "-c", "cd /work && java -jar /home/concord/.m2/repository/com/walmartlabs/concord/runtime/v2/concord-runner-v2/${CONCORD_VERSION}/concord-runner-v2-${CONCORD_VERSION}-jar-with-dependencies.jar ${RUNNER_ARGS}"]
