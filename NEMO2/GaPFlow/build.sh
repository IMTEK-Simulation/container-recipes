#!/bin/bash
#
# Build GaPFlow container for NEMO2
#
# Usage:
#   ./build.sh                    # Build with default versions
#   ./build.sh --gapflow 1.2.0    # Build specific GaPFlow version
#   ./build.sh --mugrid 1.0.0     # Build against specific muGrid version
#

set -e

# Directory containing this script (and the .def recipes)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default versions
GAPFLOW_VERSION="${GAPFLOW_VERSION:-1.2.0}"
MUGRID_VERSION="${MUGRID_VERSION:-1.4.0}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --gapflow)
            GAPFLOW_VERSION="$2"
            shift 2
            ;;
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

# Recipe and output filename with version
DEF_FILE="${SCRIPT_DIR}/gapflow.def"
OUTPUT_FILE="nemo2-gapflow-${GAPFLOW_VERSION}.sif"


echo "Building GaPFlow container with:"
echo "  GaPFlow version: ${GAPFLOW_VERSION}"
echo "  muGrid version:  ${MUGRID_VERSION}"
echo "  Recipe:          ${DEF_FILE}"
echo "  Output file:     ${OUTPUT_FILE}"
echo ""

apptainer build -F \
    --build-arg GAPFLOW_VERSION=${GAPFLOW_VERSION} \
    --build-arg MUGRID_VERSION=${MUGRID_VERSION} \
    "${OUTPUT_FILE}" "${DEF_FILE}"

echo ""
echo "Build complete: ${OUTPUT_FILE}"
echo "Test with: apptainer exec ${OUTPUT_FILE} gpf_info"
