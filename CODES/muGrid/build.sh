#!/bin/bash
#
# Build muGrid container
#
# Usage:
#   ./build.sh                    # Standard build (large container)
#   ./build.sh multistage         # Multi-stage minimal build
#   ./build.sh multistage cuda    # Multi-stage with CUDA
#   ./build.sh multistage rocm    # Multi-stage with ROCm
#

set -e

ARCH="${MUGRID_ARCH:-znver4}"

if [ "$1" = "multistage" ]; then
    GPU="${2:-none}"
    OUTPUT="mugrid-${GPU}.sif"
    echo "Building multi-stage container for ARCH=${ARCH}, GPU=${GPU}"
    apptainer build -F \
        --build-arg MUGRID_ARCH="${ARCH}" \
        --build-arg MUGRID_GPU="${GPU}" \
        "${OUTPUT}" mugrid-multistage.def
    echo "Built: ${OUTPUT}"
else
    echo "Building standard container (large, includes full toolchain)"
    apptainer build -F mugrid.sif mugrid.def
fi
