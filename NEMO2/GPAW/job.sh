#!/bin/bash
#SBATCH --partition=genoa
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=128
#SBATCH --time=01:00:00
#SBATCH --mem=200gb
#SBATCH --job-name=gpaw-diamond
#SBATCH --output=gpaw-%j.out
#SBATCH --error=gpaw-%j.err

# GPAW diamond calculation on NEMO2 genoa partition
#
# Submit with: sbatch job.sh
#
# This runs on 2 nodes with 128 tasks per node (256 total MPI ranks).
# Adjust --ntasks-per-node if you need more memory per task.

# Container image (update version as needed)
CONTAINER="gpaw-25.1.0_setups-24.11.0.sif"

# Print job info
echo "================================================"
echo "GPAW Diamond Calculation"
echo "Job ID:     ${SLURM_JOB_ID}"
echo "Nodes:      ${SLURM_NNODES}"
echo "Tasks:      ${SLURM_NTASKS}"
echo "Container:  ${CONTAINER}"
echo "Started:    $(date)"
echo "================================================"

# Run GPAW calculation
# Note: Do NOT load any MPI module - the container has its own MPI stack
srun apptainer run ${CONTAINER} diamond.py

echo "================================================"
echo "Finished:   $(date)"
echo "================================================"
