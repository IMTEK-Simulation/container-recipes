# muGrid Container for NEMO2

Container recipes for [muGrid](https://github.com/muSpectre/muGrid), a library for grid-based computations, optimized for NEMO2 (AMD EPYC Milan/Zen3).

Two variants are provided:

| Recipe | MPI | File I/O |
|--------|-----|----------|
| `mugrid.def` | OpenMPI 5.0.7 (matching NEMO2) | PnetCDF (parallel) |
| `mugrid-serial.def` | none | Unidata NetCDF (serial) |

## Build

```bash
# Build the MPI container
./build.sh

# Build the serial (non-MPI) container
./build.sh --serial

# Build a specific muGrid version
./build.sh --mugrid 1.0.0

# Or manually:
apptainer build -F mugrid.sif mugrid.def
apptainer build -F mugrid-serial.sif mugrid-serial.def
```

Both recipes are self-contained multi-stage builds. The MPI recipe compiles the entire MPI stack from scratch, matching the native NEMO2 configuration:

| Component | Version |
|-----------|---------|
| OpenMPI | 5.0.7 |
| PMIx | 5.0.7 |
| UCX | 1.16.0 |
| UCC | 1.3.0 |
| PnetCDF | 1.14.0 |
| muGrid | 1.0.0 |

The serial recipe contains none of the MPI stack; PnetCDF is replaced by Unidata NetCDF 4.9.3 (classic/CDF5 formats, built without HDF5).

muGrid needs no FFT library: it uses the bundled pocketfft.

## Usage

```bash
# Run Python script (MPI container)
srun apptainer run mugrid.sif script.py

# Report the build configuration
apptainer exec mugrid.sif python3 -c "import muGrid; print(muGrid.version_string())"

# With MPI
srun apptainer exec mugrid.sif python3 script.py

# Serial container: no srun
apptainer run mugrid-serial.sif script.py
```

### Example: Poisson Solver

The examples live in the [muGrid repository](https://github.com/muSpectre/muGrid/tree/main/examples):

```bash
wget https://raw.githubusercontent.com/muSpectre/muGrid/main/examples/poisson.py

# Run the Poisson equation example
apptainer exec mugrid.sif python3 poisson.py -n 128,128

# With JSON output
apptainer exec mugrid.sif python3 poisson.py -n 128,128 -q --json

# Run with MPI
srun -n 4 apptainer exec mugrid.sif python3 poisson.py -n 256,256
```

## Notes

- Build info is stored in `/etc/mugrid-build-info` inside the container
- Do NOT load any MPI module on NEMO2; Slurm handles process management via PMIx
- Do NOT launch the serial container with `srun`/`mpirun`; every task would repeat the identical calculation
- Container size: ~130 MB for the MPI variant, less for the serial one (minimal runtime, no compilers)
