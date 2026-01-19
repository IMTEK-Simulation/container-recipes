# muGrid Container for NEMO2

Container recipe for [muGrid](https://github.com/muSpectre/muGrid), a library for grid-based computations with MPI support, optimized for NEMO2 (AMD EPYC Milan/Zen3).

## Build

```bash
# Build the container
./build.sh

# Or manually:
apptainer build -F mugrid.sif mugrid.def
```

The recipe is a self-contained multi-stage build that compiles the entire MPI stack from scratch, matching the native NEMO2 configuration:

| Component | Version |
|-----------|---------|
| OpenMPI | 5.0.7 |
| PMIx | 5.0.7 |
| UCX | 1.16.0 |
| UCC | 1.3.0 |
| FFTW | 3.3.10 |
| PnetCDF | 1.14.0 |
| muGrid | 0.102.0 |

## Usage

```bash
# Run Python script
srun apptainer run mugrid.sif script.py

# Execute command
apptainer exec mugrid.sif python3 -c "import muGrid; print(muGrid.__version__)"

# With MPI
srun apptainer exec mugrid.sif python3 script.py
```

### Example: Poisson Solver

```bash
# Run the included Poisson equation example
apptainer exec mugrid.sif python3 poisson.py -n 128,128

# With JSON output
apptainer exec mugrid.sif python3 poisson.py -n 128,128 -q --json

# Run with MPI
srun -n 4 apptainer exec mugrid.sif python3 poisson.py -n 256,256
```

## Notes

- Build info is stored in `/etc/mugrid-build-info` inside the container
- Do NOT load any MPI module on NEMO2; Slurm handles process management via PMIx
- Container size: ~130 MB (minimal runtime, no compilers)
