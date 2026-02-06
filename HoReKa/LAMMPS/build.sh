#!/bin/bash
# Build script for LAMMPS container on HoReKa
#
# Usage:
#   ./build.sh                                # Build with default version
#   ./build.sh --lammps stable_29Aug2024      # Build specific LAMMPS version
#
# The container is self-contained and does not require any base images.

set -e

# Default version (from lammps.def)
LAMMPS_VERSION="${LAMMPS_VERSION:-stable_22Jul2025_update3}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --lammps)
            LAMMPS_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Output filename with version
OUTPUT_FILE="lammps-${LAMMPS_VERSION}.sif"

echo "Building LAMMPS container with:"
echo "  LAMMPS version: ${LAMMPS_VERSION}"
echo "  Output file:    ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg LAMMPS_VERSION=${LAMMPS_VERSION} \
    "${OUTPUT_FILE}" lammps.def

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} lmp -h"
