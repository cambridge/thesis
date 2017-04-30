#!/usr/bin/env python
import logging
from os import listdir, environ
from os.path import join
from subprocess import check_call


logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.INFO)

_build_dir = 'build'
_samples_source_dir = 'Samples'
_tests_dir = join('.circleci', 'tests')
_samples_build_dir = join(_build_dir, 'samples')
_pdfs_dir = join(_build_dir, 'pdfs')


def main():
    # _clean_build_dir()
    # _copy_sources_to_build_dir(_samples_source_dir)
    # _copy_sources_to_build_dir(_tests_dir)
    # _build()
    if environ['CIRCLECI'] == 'true':
        logging.info("RUNNING IN CIRCLECI")


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


if __name__ == '__main__':
    main()
