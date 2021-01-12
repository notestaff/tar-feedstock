#!/bin/bash

set -euo pipefail

mkdir -p $PREFIX/lib
cp $BUILD_PREFIX/share/gnuconfig/config.* build-aux/
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=$PREFIX
make -j${CPU_COUNT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" ]]; then
  make check
  make installcheck
fi
