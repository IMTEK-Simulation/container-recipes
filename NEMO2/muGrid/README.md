# muGrid Container

Container recipes for [muGrid](https://github.com/muSpectre/muGrid), a library for grid-based computations with MPI support.

## Recipe Files

| File | Description |
|------|-------------|
| `mugrid.def` | Standard single-stage build (large, includes full toolchain) |
| `mugrid-multistage.def` | Multi-stage build for minimal runtime containers |
| `mugrid-mu300a.def` | MI300A-specific build (ROCm) |

## Multi-Stage Build

The `mugrid-multistage.def` recipe uses Apptainer multi-stage builds to create minimal runtime containers. This significantly reduces container size by excluding compilers, headers, and static libraries.

### Size Comparison

| Container | Base Size | Final Size | Reduction |
|-----------|-----------|------------|-----------|
| Full stack (CUDA) | ~4.8 GB | ~200 MB | ~96% |

### Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `MUGRID_ARCH` | `native` | CPU architecture (`znver4`, `skylake`, `sandybridge`, etc.) |
| `MUGRID_GPU` | `none` | GPU backend (`none`, `cuda`, `rocm`) |
| `MUGRID_VERSION` | `0.102.0` | muGrid version/branch to build |

### Build Commands

```bash
# CPU-only for NEMO2 (Zen4):
apptainer build --build-arg MUGRID_ARCH=znver4 --build-arg MUGRID_GPU=none \
    mugrid-cpu.sif mugrid-multistage.def

# With CUDA support:
apptainer build --build-arg MUGRID_ARCH=znver4 --build-arg MUGRID_GPU=cuda \
    mugrid-cuda.sif mugrid-multistage.def

# With ROCm support:
apptainer build --build-arg MUGRID_ARCH=znver4 --build-arg MUGRID_GPU=rocm \
    mugrid-rocm.sif mugrid-multistage.def
```

### Prerequisites

The multi-stage build requires a base container with MPI, PnetCDF, and (optionally) GPU toolkit:

```bash
# Create symlink to appropriate base container
ln -sf ../../STACK/netcdf_fftw_pfft-cuda.sif netcdf_fftw_pfft.sif   # For CUDA
ln -sf ../../STACK/netcdf_fftw_pfft-rocm.sif netcdf_fftw_pfft.sif   # For ROCm
ln -sf ../../STACK/netcdf_fftw_pfft.sif netcdf_fftw_pfft.sif        # For CPU-only
```

## Usage

```bash
# Run Python script
apptainer run mugrid.sif script.py

# Execute command
apptainer exec mugrid.sif python3 -c "import muGrid; print(muGrid.__version__)"

# With MPI
srun apptainer exec mugrid.sif python3 script.py

# With GPU support
srun apptainer exec --nv mugrid.sif ...    # NVIDIA
srun apptainer exec --rocm mugrid.sif ...  # AMD
```

### Example: Poisson Solver

```bash
# Run the included Poisson equation example
apptainer exec mugrid.sif python3 poisson.py --nb-grid-pts 128,128

# With JSON output
apptainer exec mugrid.sif python3 poisson.py --nb-grid-pts 128,128 --quiet --json
```

## Notes

- The multi-stage build includes CUDA stub libraries even for CPU-only builds because mpi4py in the base container was compiled with CUDA support. This causes harmless warnings about `libnvidia-ml.so` on systems without NVIDIA GPUs.
- Build info is stored in `/etc/mugrid-build-info` inside the container.
- Dependencies: PnetCDF (parallel NetCDF) for I/O. FFTW/PFFT are not required by muGrid.
