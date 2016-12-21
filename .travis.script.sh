#! /bin/bash

set -e;

BUILD_DIR=build;


###
## LOGGING

Color_Off='\033[0m'       # Text Reset
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

function logInfo {
  echo -e "${BWhite}[INFO] $1${Color_Off}";
}

function logSuccess {
  echo -e "${BGreen}[INFO] $1${Color_Off}";
}

function logFatal {
  echo -e "${BRed}$1${Color_Off}";
  exit 1;
}


###
## Input parameter checks

if [[ -z "$BINTRAY_API_KEY" ]]; then
  logFatal "BinTray API key is required. Please specify: BINTRAY_API_KEY=xyz";
fi

if [[ -z $TRAVIS_BUILD_NUMBER ]]; then
  logFatal "Travis build number is required. Please specify: TRAVIS_BUILD_NUMBER=xyz";
fi

if [[ ( -z $TRAVIS_PULL_REQUEST ) && ( -z $TRAVIS_BRANCH ) ]]; then
  logFatal "Specify either the pull request number or the name of the branch. Please specify:
TRAVIS_PULL_REQUEST=xyz or TRAVIS_BRANCH=xyz";
fi


###
## Utility functions

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
  logInfo "Uploading: https://api.bintray.com/content/matej/cam-thesis/$packageName/$version/$remoteArtifactName";

  curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/$packageName/$version/$remoteArtifactName;
  curl -X PUT -T $fileToUpload -umatej:$BINTRAY_API_KEY "https://api.bintray.com/content/matej/cam-thesis/$remoteArtifactName;bt_package=$packageName;bt_version=$version;publish=1;override=1";

  echo "";
  logSuccess "Uploaded to: https://dl.bintray.com/matej/cam-thesis/$remoteArtifactName";
}

function deleteBinTrayPackage {
  curl -X DELETE -umatej:$BINTRAY_API_KEY "https://api.bintray.com/packages/matej/cam-thesis/$1";
  echo "";
}

function createBinTrayPackage {
  curl -X POST -H "Content-Type: application/json" -d "{\"name\": \"$1\", \"licenses\": [\"BSD\"], \"vcs_url\": \"https://github.com/cambridge/thesis\"}" -umatej:$BINTRAY_API_KEY "https://api.bintray.com/packages/matej/cam-thesis";
  echo "";
}

function listSamples {
  find $1 -maxdepth 1 -mindepth 1 -type d;
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
  logInfo "Building 'thesis.pdf'";
  make
  logSuccess "Successfully produced: 'thesis.pdf'";
}

function buildSamples {
  for sampleDir in `listSamples Samples/`; do
    logInfo "Building 'sample-${sampleDir##*/}'";

    sampleTestDir=$(createTestDir $sampleDir);

    (cd $sampleTestDir && make);

    logSuccess "Successfully produced: 'sample-${sampleDir##*/}'";
  done
}

function uploadMain {
  uploadFileToBinTray thesis.pdf $PACKAGE_NAME thesis-$VERSION.pdf $TRAVIS_BUILD_NUMBER;
}

function uploadSamples {
  for sampleDir in `listSamples $BUILD_DIR/`; do
    uploadFileToBinTray $sampleDir/thesis.pdf $PACKAGE_NAME sample-${sampleDir##*/}-$VERSION.pdf $TRAVIS_BUILD_NUMBER;
  done
}


###
## Build

PACKAGE_NAME=$(getPackageName);

logInfo "BinTray Package Name: $PACKAGE_NAME";

VERSION=$TRAVIS_BUILD_NUMBER-${TRAVIS_COMMIT:0:8}

createBinTrayPackage $PACKAGE_NAME;
buildMain;
buildSamples;
uploadMain;
uploadSamples;

if isMasterBuild; then
  deleteBinTrayPackage master-build
  createBinTrayPackage master-build
  uploadFileToBinTray thesis.pdf master-build thesis.pdf $TRAVIS_BUILD_NUMBER;
  for sampleDir in `listSamples $BUILD_DIR/`; do
    uploadFileToBinTray $sampleDir/thesis.pdf master-build sample-${sampleDir##*/}.pdf $TRAVIS_BUILD_NUMBER;
  done
fi