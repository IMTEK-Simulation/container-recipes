### Dependencies for FEniCS/DOLFINx on NEMO2

To build FEniCS/DOLFINx on the NEMO2 cluster, the following dependencies are required. These will be included and compiled within the Apptainer container:

#### 1. NEMO2-specific MPI Stack (OpenMPI 5.0.7)
- **AOCC (AMD Optimizing C/C++ Compiler):** Version 5.0.0, required for optimal performance on AMD EPYC processors.
- **HWLOC:** Version 2.10.0
- **Libfabric:** Version 1.21.0
- **MUNGE:** Version 0.5.13
- **Libevent:** Version 2.1.12
- **UCX (Unified Communication X):** Version 1.16.0, configured with InfiniBand (verbs) support.
- **UCC (Unified Collective Communication):** Version 1.3.0
- **PMIx:** Version 5.0.7
- **PRRTE:** Version 3.0.5
- **OpenMPI:** Version 5.0.7, configured with support for HWLOC, Libevent, Libfabric, UCX, UCC, PMIx, and PRRTE.
- **mpi4py:** Version 4.0.3

#### 2. Core Numerical Libraries
- **BLAS/LAPACK:** OpenBLAS (via system packages) or AMD-specific libraries.
- **ScaLAPACK:** Version 2.2.1
- **FFTW:** Version 3.3.10 with MPI support.
- **HDF5:** Version 1.14.3 or higher, with parallel support enabled.

#### 3. PETSc & SLEPc
- **PETSc:** Version 3.21.x or higher, configured with MPI, HDF5, ScaLAPACK, and BLAS/LAPACK support.
- **SLEPc:** Version 3.21.x or higher (must match PETSc version).

#### 4. FEniCS/DOLFINx Components (Version v0.10.0.post5)
- **basix:** Version 0.10.0.post0 (Finite element basis function library).
- **fenics-ufcx:** Version 0.10.0 (Finite element form compiler interface).
- **fenics-ffcx:** Version 0.10.1 (FEniCS form compiler).
- **dolfinx:** Version 0.10.0.post5 (The main C++/Python library).
- **UFL:** Version 2025.2.0.post0 (Unified Form Language).
- **pybind11:** Version 2.13.6.
- **nanobind:** Version 2.2.0 (Modern C++/Python binding tool).
- **scikit-build-core:** Build system for Python extensions.
- **pugixml:** XML parser (required for DOLFINx v0.10+).
- **spdlog:** Fast C++ logging library (required for DOLFINx v0.10+).
- **Boost:** (specifically `timer` component) required for DOLFINx v0.10+.

#### 5. Build Tools
- **CMake:** Version 3.28+
- **Python:** 3.12+ (Ubuntu 24.04 base)
- **pip/setuptools:** For Python package management.
- **Ninja:** Recommended for faster builds.
