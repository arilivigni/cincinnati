#!/bin/bash

# AppSRE team CD
# This is a buildah version of the docker script

set -exv

DOCKERFILE_BUILD="$DOCKERFILE_CONTEXT_DIR/Dockerfile.build"
DOCKERFILE_DEPLOY="$DOCKERFILE_CONTEXT_DIR/Dockerfile.deploy"

# build cincinnati builder image to use as base for the deployment image
buildah bud --tls-verify=$SSL_VERIFY \
--layers \
-f $DOCKERFILE_BUILD/Dockerfile \
-t $QUAY_IMG:builder $DOCKERFILE_BUILD

# build cincinnati deploy image
buildah bud --tls-verify=$SSL_VERIFY \
--layers \
-f $DOCKERFILE_BUILD/Dockerfile \
-t $QUAY_IMG:$GIT_HASH $DOCKERFILE_DEPLOY

# deploy image with to quay.io with git hash to image tag
buildah push --tls-verify=$SSL_VERIFY \
$QUAY_IMG:$GIT_HASH \
$QUAY_IMG:$GIT_HASH

# deploy image to quay.io with latest tag
buildah push --tls-verify=$SSL_VERIFY \
$QUAY_IMG:$GIT_HASH \
$QUAY_IMG:latest