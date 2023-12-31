#!/bin/bash
#
# Build file to set up and run tests

# Change to repo root
cd $(dirname $0)/../../..

# Prepare worker environment to run tests
KOKORO_INSTALL_VENV=yes
source kokoro/macos/prepare_build_macos_rc

bazel test //python/... //python:python_version \
  $(kokoro/common/bazel_flags.sh) \
  --macos_minimum_os=10.9 \
  --define=use_fast_cpp_protos=true
