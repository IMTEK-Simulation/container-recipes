#!/bin/bash
#
# Build muGrid container for NEMO2
#
# Usage:
#   ./build.sh                    # Build with default version
#   ./build.sh --mugrid 0.105.1   # Build specific muGrid version
#

set -e

# Default version
MUGRID_VERSION="${MUGRID_VERSION:-0.105.1}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --mugrid)
            MUGRID_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Output filename with version
OUTPUT_FILE="mugrid-${MUGRID_VERSION}.sif"

echo "Building muGrid container with:"
echo "  muGrid version: ${MUGRID_VERSION}"
echo "  Output file:    ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg MUGRID_VERSION=${MUGRID_VERSION} \
    "${OUTPUT_FILE}" mugrid.def

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} python3 -c \"import muGrid; print(muGrid.__version__)\""
