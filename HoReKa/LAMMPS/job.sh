#!/bin/bash
#SBATCH --job-name=mpiBench
#SBATCH --partition=dev_cpuonly    # Partitions: cpuonly, dev_cpuonly, accelerated, dev_accelerated
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=76       # HoReKa has 76 cores per CPU node (2 Sockets)
#SBATCH --time=00:10:00            # Set your desired wall time (HH:MM:SS)
#SBATCH --output=lammps_%j.out
#SBATCH --error=lammps_%j.err
#SBATCH --account=hk-project-p0026618

# ==============================================================================
# HoReKa LAMMPS Job Script
# ==============================================================================

# Load recommended host modules for OpenMPI 5.0 compatibility
# These modules ensure the host's PMIx/Slurm environment matches the container.
module purge
module load compiler/gnu/13
module load mpi/openmpi/5.0

# Set container image path (adjust if using a different version)
CONTAINER="horeka-lammps-stable_22Jul2025_update3.sif"

# Check if container exists
if [ ! -f "${CONTAINER}" ]; then
    echo "Error: Container ${CONTAINER} not found!"
    exit 1
fi

# Run LAMMPS using the container
# IMPORTANT: --mpi=pmix is MANDATORY on HoReKa for OpenMPI 5.x containers
# because OpenMPI 5.x has dropped support for the legacy PMI-2 interface.
echo "Starting LAMMPS simulation at $(date)"

#srun --mpi=pmix apptainer exec "${CONTAINER}" lmp -in input.lammps
srun --mpi=pmix apptainer exec "${CONTAINER}" /opt/mpiBench/mpiBench

echo "Simulation finished at $(date)"

