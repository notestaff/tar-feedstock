#!/bin/bash

set -euo pipefail

mkdir -p $PREFIX/lib
cp $BUILD_PREFIX/share/gnuconfig/config.* build-aux/

if [[ "$target_platform" == osx-* ]]; then
  # This breaks the tests when the build is run as root (as on CI)
  export gl_cv_func_mknod_works=no
  export gl_cv_func_getcwd_abort_bug=no
fi

./configure --prefix=$PREFIX
make -j${CPU_COUNT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" ]]; then
  # There are some known issues on older macOS releases
  if [[ "$target_platform" == "osx-64" ]]; then
    make installcheck "TESTSUITEFLAGS=-j${CPU_COUNT} 1-50 52-88 90-237"
  else
    make installcheck
  fi
fi
