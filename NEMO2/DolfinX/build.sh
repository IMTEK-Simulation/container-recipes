#!/bin/bash
# Build script for DOLFINx container on NEMO2
#
# Usage:
#   ./build.sh                    # Build with default versions
#
# The container is self-contained and does not require any base images.

set -e

# Default versions (matching dolfinx.def %arguments)
DOLFINX_VERSION="${DOLFINX_VERSION:-0.10.0.post5}"
BASIX_VERSION="${BASIX_VERSION:-0.10.0.post0}"
UFCX_VERSION="${UFCX_VERSION:-0.10.0}"
FFCX_VERSION="${FFCX_VERSION:-0.10.1}"
PETSC_VERSION="${PETSC_VERSION:-3.21.5}"
SLEPC_VERSION="${SLEPC_VERSION:-3.21.2}"

# Output filename with versions
OUTPUT_FILE="nemo2-dolfinx-${DOLFINX_VERSION}.sif"

echo "Building DOLFINx container with:"
echo "  DOLFINx version: ${DOLFINX_VERSION}"
echo "  Basix version:   ${BASIX_VERSION}"
echo "  FFCx version:    ${FFCX_VERSION}"
echo "  PETSc version:   ${PETSC_VERSION}"
echo "  SLEPc version:   ${SLEPC_VERSION}"
echo "  Output file:     ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg DOLFINX_VERSION=${DOLFINX_VERSION} \
    --build-arg BASIX_VERSION=${BASIX_VERSION} \
    --build-arg UFCX_VERSION=${UFCX_VERSION} \
    --build-arg FFCX_VERSION=${FFCX_VERSION} \
    --build-arg PETSC_VERSION=${PETSC_VERSION} \
    --build-arg SLEPC_VERSION=${SLEPC_VERSION} \
    "${OUTPUT_FILE}" dolfinx.def

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} python3 -c 'import dolfinx; print(dolfinx.__version__)'"
