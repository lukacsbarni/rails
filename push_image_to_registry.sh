#!/bin/bash

LOCAL_IMAGE=rails_ruby
REMOTE_IMAGE=piktochart_ruby
TAG=`git rev-parse --short HEAD`

docker login -u $1 --password-stdin $2

docker tag $LOCAL_IMAGE blukacs/$REMOTE_IMAGE:latest
docker tag $LOCAL_IMAGE blukacs/$REMOTE_IMAGE:$TAG

docker push blukacs/$REMOTE_IMAGE:latest
docker push blukacs/$REMOTE_IMAGE:$TAG

