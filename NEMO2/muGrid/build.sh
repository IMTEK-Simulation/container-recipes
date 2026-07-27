#!/bin/bash
#
# Build muGrid container for NEMO2
#
# Usage:
#   ./build.sh                    # Build MPI container with default version
#   ./build.sh --mugrid 1.0.0     # Build specific muGrid version
#   ./build.sh --serial           # Build the serial (non-MPI) container
#

set -e

# Default version
MUGRID_VERSION="${MUGRID_VERSION:-1.0.0}"

# MPI build by default
SERIAL=0

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --mugrid)
            MUGRID_VERSION="$2"
            shift 2
            ;;
        --serial)
            SERIAL=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Recipe and output filename with version
if [[ ${SERIAL} -eq 1 ]]; then
    DEF_FILE="mugrid-serial.def"
    OUTPUT_FILE="nemo2-mugrid-serial-${MUGRID_VERSION}.sif"
else
    DEF_FILE="mugrid.def"
    OUTPUT_FILE="nemo2-mugrid-${MUGRID_VERSION}.sif"
fi

echo "Building muGrid container with:"
echo "  muGrid version: ${MUGRID_VERSION}"
echo "  MPI:            $([[ ${SERIAL} -eq 1 ]] && echo disabled || echo enabled)"
echo "  Recipe:         ${DEF_FILE}"
echo "  Output file:    ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg MUGRID_VERSION=${MUGRID_VERSION} \
    "${OUTPUT_FILE}" "${DEF_FILE}"

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} python3 -c \"import muGrid; print(muGrid.version_string())\""
