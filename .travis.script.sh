#! /bin/bash

set -e;

function getVersion {
  [[ $TRAVIS_PULL_REQUEST -eq 'false' ]] && echo -n $TRAVIS_BRANCH || echo -n $TRAVIS_PULL_REQUEST.$TRAVIS_BUILD_NUMBER.$(date +%Y-%m-%d.%H%M%S).$TRAVIS_COMMIT;
}

function uploadFileToBinTray {
  local fileToUpload=$1;
  local remoteArtifactId=$2;
  local version=$3;
  local fakeVersion='1.0.1'
  curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/$fakeVersion/$remoteArtifactId-$version.pdf
  curl -X PUT -T $fileToUpload -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/$fakeVersion/$remoteArtifactId-$version.pdf?publish=1  
}

export BUILD_VERSION=$(getVersion)

make

uploadFileToBinTray thesis.pdf thesis $BUILD_VERSION

cd Samples/clean
ln -s ../../CollegeShields .
ln -s ../../cam-thesis.cls .
ln -s ../../Makefile .
make
uploadFileToBinTray thesis.pdf SampleClean $BUILD_VERSION
