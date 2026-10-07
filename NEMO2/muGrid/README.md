# muGrid Container for NEMO2

Container recipes for [muGrid](https://github.com/muSpectre/muGrid), a library for grid-based computations, optimized for NEMO2 (AMD EPYC Milan/Zen3).

Two variants are provided:

| Recipe | MPI | File I/O |
|--------|-----|----------|
| `mugrid.def` | OpenMPI 5.0.11 | PnetCDF (parallel) |
| `mugrid-serial.def` | none | Unidata NetCDF (serial) |

## Build

```bash
# Build the MPI container
./build.sh

# Build the serial (non-MPI) container
./build.sh --serial

# Build a specific muGrid version
./build.sh --mugrid 1.3.0

# Or manually:
apptainer build -F mugrid.sif mugrid.def
apptainer build -F mugrid-serial.sif mugrid-serial.def
```

Both recipes are self-contained multi-stage builds. The MPI recipe compiles the entire MPI stack from scratch, with the same versions as the NEMO2 base container (`MACHINES/NEMO2/openmpi-5.0.11_ucx-1.22.0.def`):

| Component | Version |
|-----------|---------|
| AOCC | 5.2.0 |
| OpenMPI | 5.0.11 |
| PMIx | 5.0.11 |
| PRRTE | 3.0.14 |
| UCX | 1.22.0 |
| UCC | 1.9.0 |
| libfabric | 2.7.0 |
| hwloc | 2.14.0 |
| mpi4py | 4.1.2 |
| PnetCDF | 1.15.1 |
| muGrid | 1.4.0 |

The serial recipe contains none of the MPI stack; PnetCDF is replaced by Unidata NetCDF 4.10.1 (classic/CDF5 formats, built without HDF5).

All code is compiled with `-march=znver3`, so the containers run on both the Milan (Zen3) and the Genoa (Zen4) nodes of NEMO2.

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

Use plain `srun`. It uses NEMO2's default PMIx plugin (`pmix_v3`), which works with the container's PMIx 5. Do not pass `--mpi=pmix`. On NEMO2 this selects a different plugin version, and job steps then hung on launch in our tests.

### Batch job

`job.sh` is an example job script. It runs the Poisson example below on 2 milan nodes (256 MPI ranks):

```bash
sbatch job.sh                                # expects nemo2-mugrid-1.4.0.sif from ./build.sh
CONTAINER=/path/to/mugrid.sif sbatch job.sh  # or point it to another image
```

### Example: Poisson Solver

The examples live in the [muGrid repository](https://github.com/muSpectre/muGrid/tree/main/examples). Fetch them from the tag that matches the muGrid version in the container:

```bash
wget https://raw.githubusercontent.com/muSpectre/muGrid/1.4.0/examples/poisson.py

# Run the Poisson equation example
apptainer exec mugrid.sif python3 poisson.py -n 128,128

# With JSON output
apptainer exec mugrid.sif python3 poisson.py -n 128,128 -q --json

# Run with MPI
srun -n 4 apptainer exec mugrid.sif python3 poisson.py -n 256,256

# Larger grids: the Fourier preconditioner converges in a few iterations
# (plain CG does not converge within the default 1000 iterations at 2048x2048)
srun apptainer exec mugrid.sif python3 poisson.py -n 2048,2048 -P fourier -q

# Serial container
apptainer exec mugrid-serial.sif python3 poisson.py -n 128,128
```

## Notes

- Build info is stored in `/etc/mugrid-build-info` inside the container
- Do NOT load any MPI module on NEMO2; Slurm handles process management via PMIx
- Do NOT launch the serial container with `srun`/`mpirun`; every task would repeat the identical calculation
- Container size: ~140 MB for the MPI variant, ~115 MB for the serial one (minimal runtime, no compilers)
