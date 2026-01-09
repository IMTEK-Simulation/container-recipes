# NEMO2-CUDA Base Container

Base container for NEMO2 H200 GPU partition with CUDA support for GPU-aware MPI.

## Building

```bash
./build.sh
```

The container can be built on any Linux system with Apptainer installed - it does not require GPU hardware. CUDA toolkit is installed from NVIDIA's package repository. The GPU kernel driver is only required at runtime on the host.

Note: The container is compiled with `-march=znver4` for Zen 4 CPUs (AMD EPYC 9654). This means:
- You need to build on a Zen 4 machine, or use cross-compilation
- The resulting container will only run on Zen 4 or newer AMD CPUs

## Components

- Ubuntu 24.04
- CUDA 12.6 Toolkit
- OpenMPI 5.0.7 with CUDA support
- UCX 1.16.0 with CUDA support (GPU-aware transport)
- UCC 1.3.0 with CUDA support (GPU-aware collectives)
- mpi4py 4.0.3

All communication libraries are compiled with `--with-cuda` to enable GPU-aware MPI, allowing direct GPU buffer transfers without staging through host memory.

## Usage

### Running MPI applications

```bash
srun apptainer exec --nv mpibase-cuda.sif ./your_application
```

The `--nv` flag binds the host GPU devices and NVIDIA driver into the container.

### Running Python scripts

```bash
srun apptainer run --nv mpibase-cuda.sif your_script.py
```

### Compiling CUDA code with MPI

```bash
apptainer exec --nv mpibase-cuda.sif nvcc -ccbin mpicxx -o program program.cu
```

### MPI benchmark

```bash
srun apptainer exec --nv mpibase-cuda.sif /opt/mpiBench/mpiBench
```

## Environment Variables

The container sets:
- `CUDA_HOME=/usr/local/cuda`
- CUDA binaries and libraries in PATH/LD_LIBRARY_PATH

For GPU-aware MPI, UCX is the recommended transport:
```bash
export OMPI_MCA_pml=ucx
```

## Verification

Check CUDA support in OpenMPI:
```bash
apptainer exec --nv mpibase-cuda.sif ompi_info | grep cuda
```

Check UCX CUDA support:
```bash
apptainer exec --nv mpibase-cuda.sif ucx_info -d | grep cuda
```

List available GPUs:
```bash
apptainer exec --nv mpibase-cuda.sif nvidia-smi
```

## H200 GPU Architecture

The NVIDIA H200 uses the Hopper architecture (sm_90). When compiling CUDA code targeting H200:
```bash
nvcc -arch=sm_90 ...
```
