# NEMO2-ROCm Base Container

Base container for NEMO2 MI300A GPU partition with ROCm support for GPU-aware MPI.

## Building

```bash
./build.sh
```

The container can be built on any Linux system with Apptainer installed - it does not require GPU hardware. ROCm userspace libraries are installed from AMD's package repository. The GPU kernel driver is only required at runtime on the host.

Note: The container is compiled with `-march=znver4` for Zen4 CPUs (MI300A has integrated Zen4 cores). This means:
- You can build on any machine (Intel, older AMD, etc.)
- The resulting container will only run on Zen4 or newer AMD CPUs

## Components

- Ubuntu 24.04
- ROCm 6.4 (HIP, hipBLAS, rocBLAS, rocFFT, rocSOLVER, hipSPARSE, rocPRIM, rocThrust)
- OpenMPI 5.0.7 with ROCm support
- UCX 1.16.0 with ROCm support (GPU-aware transport)
- UCC 1.3.0 with ROCm support (GPU-aware collectives)
- mpi4py 4.0.3

All communication libraries are compiled with `--with-rocm=/opt/rocm` to enable GPU-aware MPI, allowing direct GPU buffer transfers without staging through host memory.

## Usage

### Running MPI applications

```bash
srun apptainer exec --rocm mpibase-rocm.sif ./your_application
```

The `--rocm` flag binds the host GPU devices into the container.

### Running Python scripts

```bash
srun apptainer run --rocm mpibase-rocm.sif your_script.py
```

### Compiling HIP code with MPI

```bash
export OMPI_CXX=hipcc
apptainer exec --rocm mpibase-rocm.sif mpicxx -o program program.cpp
```

### MPI benchmark

```bash
srun apptainer exec --rocm mpibase-rocm.sif /opt/mpiBench/mpiBench
```

## Environment Variables

The container sets:
- `ROCM_PATH=/opt/rocm`
- ROCm binaries and libraries in PATH/LD_LIBRARY_PATH

For GPU-aware MPI, UCX is the recommended transport:
```bash
export OMPI_MCA_pml=ucx
```

## Verification

Check ROCm support in OpenMPI:
```bash
apptainer exec --rocm mpibase-rocm.sif ompi_info | grep rocm
```

Check UCX ROCm support:
```bash
apptainer exec --rocm mpibase-rocm.sif ucx_info -d | grep rocm
```

List available GPUs:
```bash
apptainer exec --rocm mpibase-rocm.sif rocm-smi
```
