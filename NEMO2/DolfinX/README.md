# DOLFINx (FEniCS) Container for NEMO2

High-performance container recipe for [DOLFINx](https://github.com/FEniCS/dolfinx), the next-generation finite element library from the FEniCS Project. Optimized for NEMO2 (AMD EPYC Milan/Zen3).

## Build

```bash
# Build the container
./build.sh

# Or manually:
apptainer build -F dolfinx.sif dolfinx.def
```

The recipe is a self-contained multi-stage build that compiles the entire MPI stack and scientific libraries from scratch, matching the native NEMO2 configuration.

### Software Stack

| Component | Version |
|-----------|---------|
| DOLFINx | 0.10.0.post5 |
| Basix | 0.10.0.post0 |
| FFCx | 0.10.1 |
| PETSc | 3.21.5 |
| SLEPc | 3.21.2 |
| OpenMPI | 5.0.7 |
| UCX | 1.16.0 |
| UCC | 1.3.0 |
| HDF5 | 1.14.3 |

## Usage

```bash
# Run Python script
srun apptainer run dolfinx.sif script.py

# Execute command
apptainer exec dolfinx.sif python3 -c "import dolfinx; print(dolfinx.__version__)"

# With MPI (on NEMO2)
srun apptainer exec dolfinx.sif python3 script.py
```

## Notes

- Build info is stored in `/etc/dolfinx-build-info` inside the container.
- Do NOT load any MPI module on NEMO2; Slurm handles process management via PMIx.
- The container uses a multi-stage build to provide a minimal runtime image without compilers or build tools.
