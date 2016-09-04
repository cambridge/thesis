#! /bin/bash

set -e;

BUILD_DIR=build;

function getPackageName {
  if isPullRequest; then
    echo -n "pull-request-$TRAVIS_PULL_REQUEST";
  else
    echo -n ${TRAVIS_BRANCH/\//_};
  fi
}

function isPullRequest {
  [[ $TRAVIS_PULL_REQUEST != false ]];
}

function isMasterBuild {
  ! isPullRequest && [[ $TRAVIS_BRANCH = 'master' ]];
}

function uploadFileToBinTray {
  local fileToUpload=$1;
  local packageName=$2;
  local remoteArtifactName=$3;
  local version=$4;
  curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/$packageName/$version/$remoteArtifactName;
  curl -X PUT -T $fileToUpload -umatej:$BINTRAY_API_KEY "https://api.bintray.com/content/matej/cam-thesis/$remoteArtifactName;bt_package=$packageName;bt_version=$version;publish=1;override=1";
}

function deleteBinTrayPackage {
  curl -X DELETE -umatej:$BINTRAY_API_KEY "https://api.bintray.com/packages/matej/cam-thesis/$1";
}

function createBinTrayPackage {
  curl -X POST -H "Content-Type: application/json" -d "{\"name\": \"$1\", \"licenses\": [\"BSD\"], \"vcs_url\": \"https://github.com/cambridge/thesis\"}" -umatej:$BINTRAY_API_KEY "https://api.bintray.com/packages/matej/cam-thesis";
}

function createTestDir {
  local sourceDir=$1;
  local targetDir="$BUILD_DIR/${sourceDir##*/}";
  rm -Rf $targetDir;
  mkdir -p $targetDir;
  cp -r CollegeShields $targetDir;
  cp cam-thesis.cls $targetDir;
  cp Makefile $targetDir;
  cp -r $sourceDir/* $targetDir;
  echo $targetDir;
}

function buildMain {
  echo ">>> MAKING: main...";
  make
  echo ">>> MAKING: main... DONE";
}

function buildSamples {
  for sampleDir in `find Samples/ -maxdepth 1 -mindepth 1 -type d`; do
    echo ">>> MAKING: sample-${sampleDir##*/}...";
    sampleTestDir=$(createTestDir $sampleDir);

    (cd $sampleTestDir && make);
    echo ">>> MAKING: sample-${sampleDir##*/}... DONE";
  done
}

PACKAGE_NAME=$(getPackageName);

function uploadMain {
  uploadFileToBinTray thesis.pdf $PACKAGE_NAME thesis-$TRAVIS_BUILD_NUMBER.pdf $TRAVIS_BUILD_NUMBER;
}

function uploadSamples {
  for sampleDir in `find $BUILD_DIR/ -maxdepth 1 -mindepth 1 -type d`; do
    uploadFileToBinTray $sampleDir/thesis.pdf $PACKAGE_NAME sample-${sampleDir##*/}-$TRAVIS_BUILD_NUMBER.pdf $TRAVIS_BUILD_NUMBER;
  done
}

createBinTrayPackage $PACKAGE_NAME;
buildMain;
buildSamples;
uploadMain;
uploadSamples;

if isMasterBuild; then
  deleteBinTrayPackage master-build
  createBinTrayPackage master-build
  uploadFileToBinTray thesis.pdf master-build thesis.pdf $TRAVIS_BUILD_NUMBER;
  for sampleDir in `find $BUILD_DIR/ -maxdepth 1 -mindepth 1 -type d`; do
    uploadFileToBinTray $sampleDir/thesis.pdf master-build sample-${sampleDir##*/}.pdf $TRAVIS_BUILD_NUMBER;
  done
fi