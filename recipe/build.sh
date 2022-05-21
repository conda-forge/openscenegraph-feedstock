#!/bin/sh

mkdir build
cd build

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" && "${target_platform}" == "osx-arm64" ]]; then
  # Need to set these explicitly for osx-arm64 since they can't be checked
  # automatically when cross-compiling, see https://github.com/conda-forge/openscenegraph-feedstock/pull/18#issuecomment-1133066499
  export CMAKE_ARGS="${CMAKE_ARGS} -D_OPENTHREADS_ATOMIC_USE_BSD_ATOMIC_EXITCODE__TRYRUN_OUTPUT=\"\" -D_OPENTHREADS_ATOMIC_USE_BSD_ATOMIC_EXITCODE=0 -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE__TRYRUN_OUTPUT=\"\" -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=0"
  echo "Set CMAKE_ARGS To ${CMAKE_ARGS}"
fi

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib
make -j${CPU_COUNT}
make install
