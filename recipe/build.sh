#!/bin/bash

set -euo pipefail

mkdir -p $PREFIX/lib
cp $BUILD_PREFIX/share/gnuconfig/config.* build-aux/

if [[ "$target_platform" == osx-* ]]; then
  # This breaks the tests when the build is run as root (as on CI)
  export gl_cv_func_mknod_works=no
fi

./configure --prefix=$PREFIX
make -j${CPU_COUNT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" ]]; then
  make check
  make installcheck
fi
