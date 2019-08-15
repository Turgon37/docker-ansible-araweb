#!/usr/bin/env bash

## Global settings
# image name
DOCKER_IMAGE="${DOCKER_REPO:-ansible-araweb}"
# use dockefile
DOCKERFILE_PATH="Dockerfile"

## Initialization
set -e

# If empty version, fetch the latest from repository
if [[ -z "$ARAWEB_VERSION" ]]; then
  ARAWEB_VERSION=`curl --fail -s https://api.github.com/repos/ansible-community/ara-web/tags | grep --perl-regexp --only-matching '(?<=name": ")[0-9.]+' -m 1`
  if [[ $? -ne 0 ]]; then
    echo 'Error during fetch last ara-web version'
    exit 1
  fi
  test -n "$ARAWEB_VERSION"
fi
echo "-> selected ARAWEB version '${ARAWEB_VERSION}'"

# If empty commit, fetch the current from local git rpo
if [ -n "${SOURCE_COMMIT}" ]; then
  VCS_REF="${SOURCE_COMMIT}"
elif [ -n "${TRAVIS_COMMIT}" ]; then
  VCS_REF="${TRAVIS_COMMIT}"
else
  VCS_REF="`git rev-parse --short HEAD`"
fi
test -n "${VCS_REF}"
echo "-> current vcs reference '${VCS_REF}'"

# Get the current image static version
image_version=`cat VERSION`
echo "-> use image version '${image_version}'"

# Compute variant from dockerfile name
if ! [ -f ${DOCKERFILE_PATH} ]; then
  echo 'You must select a valid dockerfile with DOCKERFILE_PATH' 1>&2
  exit 1
fi
if [[ -n "${IMAGE_VARIANT}" ]]; then
  image_building_name="${DOCKER_IMAGE}:building_${IMAGE_VARIANT}"
  echo "-> set image variant '${IMAGE_VARIANT}' for build"
else
  image_building_name="${DOCKER_IMAGE}:building"
fi
echo "-> use image name '${image_building_name}' for build"

## Build image
echo "=> building '${image_building_name}' with image version '${image_version}'"
docker build --build-arg "ARAWEB_VERSION=${ARAWEB_VERSION}" \
             --label "org.label-schema.build-date=`date -u +'%Y-%m-%dT%H:%M:%SZ'`" \
             --label 'org.label-schema.name=ansible-araweb' \
             --label 'org.label-schema.description=ARA Front web application' \
             --label 'org.label-schema.url=https://github.com/Turgon37/docker-ansible-araweb' \
             --label "org.label-schema.vcs-ref=${VCS_REF}" \
             --label 'org.label-schema.vcs-url=https://github.com/Turgon37/docker-ansible-araweb' \
             --label 'org.label-schema.vendor=Pierre GINDRAUD' \
             --label "org.label-schema.version=${image_version}" \
             --label 'org.label-schema.schema-version=1.0' \
             --label "application.araserver.version=${ARAWEB_VERSION}" \
             --tag "${image_building_name}" \
             --file "${DOCKERFILE_PATH}" \
             .
