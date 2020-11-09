#!/bin/bash

if [ -z "${SNYK_TOKEN}" ]; then
  echo "Please set SNYK_TOKEN variable in CircleCI project settings"
  exit 1
fi

if [ -z "${GITHUB_PAT}" ]; then
  echo "Please set GITHUB_PAT variable in CircleCI project settings"
  exit 1
fi

## auth
snyk auth ${SNYK_TOKEN}

## set project path
PROJECT_PATH=$(eval echo ${CIRCLE_WORKING_DIRECTORY})

## set tag
TAG_NAME=latest
SNYK_FNAME=snyk.json

## lets retag the image
docker image tag ${CIRCLE_PROJECT_REPONAME}:${CIRCLE_SHA1} ${CIRCLE_PROJECT_REPONAME}:${TAG_NAME}

## test 
snyk test --docker ${CIRCLE_PROJECT_REPONAME}:${TAG_NAME} --file=${PROJECT_PATH}/Dockerfile --json > ${PROJECT_PATH}/${SNYK_FNAME}

## monitor
snyk monitor --docker ${CIRCLE_PROJECT_REPONAME}:${TAG_NAME} --file="${PROJECT_PATH}/Dockerfile"

## comment and parse
scan_results=$(parse_scan_results ${PROJECT_PATH}/${SNYK_FNAME})

[[ $scan_results ]] && comment_on_pr "$scan_results"
