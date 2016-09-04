#! /bin/bash

set -e;

function getVersion {
  [[ $TRAVIS_PULL_REQUEST -eq 'false' ]] && echo -n $TRAVIS_BRANCH || echo -n $TRAVIS_PULL_REQUEST.$TRAVIS_BUILD_NUMBER.$(date +%Y-%m-%d.%H%M%S).$TRAVIS_COMMIT;
}

export BUILD_VERSION=$(getVersion)

make

curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/1.0.0/thesis-$BUILD_VERSION.pdf
curl -X PUT -T thesis.pdf -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/1.0.0/thesis-$BUILD_VERSION.pdf?publish=1

cd Samples/clean
ln -s ../../CollegeShields .
ln -s ../../cam-thesis.cls .
ln -s ../../Makefile .
make
curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/1.0.0/thesis-$BUILD_VERSION.pdf
curl -X PUT -T thesis.pdf -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/cam-thesis/1.0.0/SampleClean-$BUILD_VERSION.pdf?publish=1