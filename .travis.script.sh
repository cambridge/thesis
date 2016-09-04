#! /bin/bash

set -e;

function getVersion {
  if [[ $TRAVIS_PULL_REQUEST -ge 1 ]]; then
    echo -n 0.0.$TRAVIS_BUILD_NUMBER-pr$TRAVIS_PULL_REQUEST;
  elif [[ $TRAVIS_BRANCH -eq 'feature/travis-multi-builds' ]]; then
    echo -n 0.0.$TRAVIS_BUILD_NUMBER;
  else
    echo -n 0.0.$TRAVIS_BUILD_NUMBER-$TRAVIS_COMMIT;
  fi
  # else
  #   echo -n $TRAVIS_PULL_REQUEST.$TRAVIS_BUILD_NUMBER.$(date +%Y-%m-%d.%H%M%S).$TRAVIS_COMMIT;
  # fi
}

function uploadFileToBinTray {
  local fileToUpload=$1;
  local remoteArtifactId=$2;
  local version=$3;
  curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/$version/$remoteArtifactId-$version.pdf
  curl -X PUT -T $fileToUpload -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/$version/$remoteArtifactId-$version.pdf?publish=1  
}

export BUILD_VERSION=$(getVersion)

echo "Branch: $TRAVIS_BRANCH";
echo "Version: $BUILD_VERSION";

exit 1;

make

uploadFileToBinTray thesis.pdf thesis $BUILD_VERSION

cd Samples/clean
ln -s ../../CollegeShields .
ln -s ../../cam-thesis.cls .
ln -s ../../Makefile .
make
uploadFileToBinTray thesis.pdf SampleClean $BUILD_VERSION
