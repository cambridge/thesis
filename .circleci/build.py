#!/usr/bin/env python
import logging
from os.path import join, basename, isfile
from subprocess import check_call

from os import listdir, environ

logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.INFO)

_build_dir = 'build'
_samples_source_dir = 'Samples'
_tests_dir = join('.circleci', 'tests')
_samples_build_dir = join(_build_dir, 'samples')
_pdfs_dir = join(_build_dir, 'pdfs')


def main():
    _clean_build_dir()
    _copy_sources_to_build_dir(_samples_source_dir)
    _copy_sources_to_build_dir(_tests_dir)
    _build()
    if _is_running_in_circle_ci():
        logging.info("BUILDING IN CIRCLECI!")
        # if environ['CIRCLE_BRANCH'] == 'master':
        for pdf in listdir(_pdfs_dir):
            pdf_path = join(_pdfs_dir, pdf)
            if isfile(pdf_path):
                _upload_file_to_bintray(pdf_path)


def _clean_build_dir():
    check_call(['rm', '-rf', _build_dir])


def _copy_sources_to_build_dir(samples_root_dir):
    _copy_main_thesis_to_build()
    for sample_dir in listdir(samples_root_dir):
        build_sample_dir = join(_samples_build_dir, sample_dir)
        check_call(['rsync', '-a', join(samples_root_dir, sample_dir), _samples_build_dir])
        _copy_base_files_to(build_sample_dir)


def _build():
    check_call(['mkdir', '-p', (_pdfs_dir)])
    for sample_name in listdir(_samples_build_dir):
        logging.info("Building '{}'...".format(sample_name))

        sample_build_dir = join(_samples_build_dir, sample_name)
        check_call(['sh', '-c', '(cd {} && make)'.format(sample_build_dir)])
        check_call(['cp',
                    '{}/thesis.pdf'.format(sample_build_dir),
                    '{}/{}.pdf'.format(_pdfs_dir, sample_name)])

        logging.info("Successfully built '{}'.".format(sample_name))


def _copy_main_thesis_to_build():
    target_dir = join(_samples_build_dir, 'thesis')
    _copy_base_files_to(target_dir)
    check_call(['cp', 'thesis.tex', 'thesis.bib', target_dir])


def _copy_base_files_to(target_dir):
    check_call(['mkdir', '-p', target_dir])
    check_call(['cp', '-r', 'cam-thesis.cls', 'Makefile', 'CollegeShields', target_dir])


def _is_running_in_circle_ci():
    return environ.get('CIRCLECI', 'false') == 'true'


def _upload_file_to_bintray(file_path, package_name=None, artifact_name=None, version=None):
    package_name = package_name or environ['CIRCLE_BRANCH']
    version = version or environ['CIRCLE_BUILD_NUM'] + '-' + environ['CIRCLE_SHA1'][:8]
    artifact_name = artifact_name or '{}-{}.pdf'.format(basename(file_path), version)

    logging.info("Uploading '%s' to BinTray...", file_path)

    bintray_credentials = '-umatej:' + environ['BINTRAY_API_KEY']
    check_call(['curl', '-X', 'DELETE', bintray_credentials,
                'https://api.bintray.com/content/matej/cam-thesis/{}/{}/{}'
               .format(package_name, version, artifact_name)])
    check_call(['curl', '-X', 'PUT', '-T', file_path, bintray_credentials,
                'https://api.bintray.com/content/matej/cam-thesis/{};bt_package={};bt_version={};publish=1;override=1'
               .format(artifact_name, package_name, version)])

    logging.info("Uploaded to 'https://bintray.com/matej/cam-thesis/download_file?file_path=%s'.", artifact_name)


# function uploadFileToBinTray {
#   local fileToUpload=$1;
#   local packageName=$2;
#   local remoteArtifactName=$3;
#   local version=$4;
#   logInfo "Uploading: https://api.bintray.com/content/matej/cam-thesis/$packageName/$version/$remoteArtifactName";
#
#   curl -X DELETE -umatej:$BINTRAY_API_KEY https://api.bintray.com/content/matej/cam-thesis/$packageName/$version/$remoteArtifactName;
#   curl -X PUT -T $fileToUpload -umatej:$BINTRAY_API_KEY "https://api.bintray.com/content/matej/cam-thesis/$remoteArtifactName;bt_package=$packageName;bt_version=$version;publish=1;override=1";
#
#   echo "";
#   logSuccess "Uploaded to: https://bintray.com/matej/cam-thesis/download_file?file_path=$remoteArtifactName";
# }


if __name__ == '__main__':
    main()
