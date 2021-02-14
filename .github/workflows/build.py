#!/usr/bin/env python
import logging
import os
import subprocess
from pathlib import Path

import boto3


logging.basicConfig(
    format="[%(levelname)s %(asctime)s] %(message)s", level=logging.INFO
)

BUILD_DIR = Path("build")
SAMPLES_SOURCE_DIR = Path("Samples")
TESTS_DIR = Path(".github/workflows/tests")
SAMPLES_BUILD_DIR = BUILD_DIR / "samples"
PDFS_DIR = BUILD_DIR / "pdfs"


def main():
    logging.info(
        "Started the build (branch: %s)...", os.environ.get("GITHUB_REF", "unknown")
    )
    _clean_build_dir()
    _copy_sources_to_build_dir(SAMPLES_SOURCE_DIR)
    _copy_sources_to_build_dir(TESTS_DIR)
    _build()
    if os.environ.get("GITHUB_REF") != "refs/heads/master":
        logging.info("Not uploading PDFs...")
        return
    logging.info("Uploading PDFs...")
    _upload_pdfs()


def _upload_pdfs():
    s3_client = boto3.client("s3")
    for pdf in PDFS_DIR.glob("*.pdf"):
        logging.info("Uploading '%s'", pdf)
        with pdf.open(mode="rb") as pdf_stream:
            s3_client.put_object(
                Bucket="cam-thesis", Key=f"pdf/{pdf.name}", Body=pdf_stream
            )


def _clean_build_dir():
    subprocess.check_call(["rm", "-rf", BUILD_DIR])


def _copy_sources_to_build_dir(samples_root_dir):
    _copy_main_thesis_to_build()
    for sample_dir in samples_root_dir.iterdir():
        build_sample_dir = SAMPLES_BUILD_DIR / sample_dir.name
        logging.info(
            "Copying sample '%s' to '%s'...", sample_dir.name, build_sample_dir
        )
        subprocess.check_call(["rsync", "-a", sample_dir, SAMPLES_BUILD_DIR])
        _copy_base_files_to(build_sample_dir)


def _build():
    subprocess.check_call(["mkdir", "-p", (PDFS_DIR)])
    for sample_dir in SAMPLES_BUILD_DIR.iterdir():
        logging.info("Building '%s'...", sample_dir.name)

        sample_build_dir = SAMPLES_BUILD_DIR / sample_dir.name
        subprocess.check_call(["make"], cwd=sample_build_dir)
        subprocess.check_call(
            [
                "cp",
                f"{sample_build_dir}/thesis.pdf",
                f"{PDFS_DIR}/{sample_dir.name}.pdf",
            ]
        )

        logging.info("Successfully built '%s'.", sample_dir.name)


def _copy_main_thesis_to_build():
    target_dir = SAMPLES_BUILD_DIR / "thesis"
    _copy_base_files_to(target_dir)
    subprocess.check_call(["cp", "thesis.tex", "thesis.bib", target_dir])


def _copy_base_files_to(target_dir):
    subprocess.check_call(["mkdir", "-p", target_dir])
    subprocess.check_call(
        ["cp", "-r", "cam-thesis.cls", "Makefile", "CollegeShields", target_dir]
    )


if __name__ == "__main__":
    main()
