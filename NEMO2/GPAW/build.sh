#!/bin/bash
# Build script for GPAW container on NEMO2
#
# Usage:
#   ./build.sh                    # Build with default versions
#   ./build.sh --gpaw 25.1.0      # Build specific GPAW version
#
# The container is self-contained and does not require any base images.

set -e

# Default versions
GPAW_VERSION="${GPAW_VERSION:-25.7.0}"
GPAW_SETUPS_VERSION="${GPAW_SETUPS_VERSION:-24.11.0}"
LIBXC_VERSION="${LIBXC_VERSION:-7.0.0}"
ASE_VERSION="${ASE_VERSION:-3.27.0}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --gpaw)
            GPAW_VERSION="$2"
            shift 2
            ;;
        --setups)
            GPAW_SETUPS_VERSION="$2"
            shift 2
            ;;
        --libxc)
            LIBXC_VERSION="$2"
            shift 2
            ;;
        --ase)
            ASE_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Output filename with versions
OUTPUT_FILE="gpaw-${GPAW_VERSION}_setups-${GPAW_SETUPS_VERSION}.sif"

echo "Building GPAW container with:"
echo "  GPAW version:   ${GPAW_VERSION}"
echo "  Setups version: ${GPAW_SETUPS_VERSION}"
echo "  libxc version:  ${LIBXC_VERSION}"
echo "  ASE version:    ${ASE_VERSION}"
echo "  Output file:    ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg GPAW_VERSION=${GPAW_VERSION} \
    --build-arg GPAW_SETUPS_VERSION=${GPAW_SETUPS_VERSION} \
    --build-arg LIBXC_VERSION=${LIBXC_VERSION} \
    --build-arg ASE_VERSION=${ASE_VERSION} \
    "${OUTPUT_FILE}" gpaw.def

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} gpaw info"
