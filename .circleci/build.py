#!/usr/bin/env python
import logging
from os.path import join, basename
from subprocess import check_call

from os import listdir, environ

logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.DEBUG)

_build_dir = 'build'
_samples_source_dir = 'Samples'
_tests_dir = join('.circleci', 'tests')
_samples_build_dir = join(_build_dir, 'samples')
_pdfs_dir = join(_build_dir, 'pdfs')
_bintray_content_api_url = 'https://api.bintray.com/content/matej/cam-thesis'
_bintray_control_api_url = 'https://api.bintray.com/packages/matej/cam-thesis'


def main():
    _clean_build_dir()
    _copy_sources_to_build_dir(_samples_source_dir)
    _copy_sources_to_build_dir(_tests_dir)
    _build()
    if _is_running_in_circle_ci():
        _upload_to_bintray()


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


def _upload_to_bintray():
    package_name = environ['CIRCLE_BRANCH'].replace('/', '_')
    version = environ['CIRCLE_BUILD_NUM'] + '-' + environ['CIRCLE_SHA1'][:8]

    _delete_bintray_package(package_name)
    _create_bintray_package(package_name)

    for pdf in listdir(_pdfs_dir):
        pdf_path = join(_pdfs_dir, pdf)
        artifact_name = '{}-{}.pdf'.format(basename(pdf_path), package_name)
        _upload_file_to_bintray(pdf_path, package_name, artifact_name, version)


def _upload_file_to_bintray(file_path, package_name, artifact_name, version):
    logging.info("Uploading '%s' to BinTray...", file_path)

    delete_url = '{}/{}/{}/{}'.format(_bintray_content_api_url, package_name, version, artifact_name)
    logging.debug("Deleting potentially existing artifact at '%s'", delete_url)
    _call_bintray_api('DELETE', delete_url)

    put_url = '{}/{};bt_package={};bt_version={};publish=1;override=1'.format(_bintray_content_api_url, artifact_name,
                                                                              package_name, version)
    logging.debug("Pushing the artifact to '%s'", put_url)
    _call_bintray_api('PUT', '-T', file_path, put_url)

    logging.info("Uploaded to 'https://bintray.com/matej/cam-thesis/download_file?file_path=%s'.", artifact_name)


def _delete_bintray_package(package_name):
    delete_url = '{}/{}'.format(_bintray_control_api_url, package_name)
    logging.debug("Deleting BinTray package: '%s'", delete_url)
    _call_bintray_api('DELETE', delete_url)


def _create_bintray_package(package_name):
    logging.debug("Creating BinTray package: '%s'", package_name)
    payload = '{"name": "%s", "licenses": ["BSD"], "vcs_url": "https://github.com/cambridge/thesis"}' % (package_name)
    _call_bintray_api('POST', '-H', 'Content-Type: application/json', '-d', payload, _bintray_control_api_url)


def _call_bintray_api(http_verb, *extra_args):
    check_call(['curl', '-X', http_verb, _get_bintray_credentials()] + list(extra_args))


def _get_bintray_credentials():
    return '-umatej:' + environ['BINTRAY_API_KEY']


if __name__ == '__main__':
    main()
