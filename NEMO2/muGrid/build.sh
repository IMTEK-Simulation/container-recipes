#!/bin/bash
#
# Build muGrid container for NEMO2
#
# Usage:
#   ./build.sh
#

set -e

echo "Building muGrid container..."
apptainer build -F mugrid.sif mugrid.def
echo "Built: mugrid.sif"
