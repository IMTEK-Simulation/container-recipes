# GPAW

## Docker

This directory contains a Docker recipe that builds [GPAW](https://wiki.fysik.dtu.dk/gpaw/) 25.7.0 with the Intel oneAPI HPC Toolkit. It uses libxc 7.0.0 and ASE 3.26.0.

Build the Docker image with:
```bash
docker build -t gpaw .
```

The image is on Docker Hub [here](https://hub.docker.com/repository/docker/pastewka/gpaw).

## Apptainer

The Docker images can be converted into an Apptainer image for use on HPC systems. Convert the image with:
```bash
apptainer build gpaw.sif docker-daemon://gpaw:latest
```

## Docker Hub

The image is also available on [Docker Hub](https://hub.docker.com). To get it from there, execute:
```bash
docker pull pastewka/gpaw
apptainer build gpaw.sif docker-daemon://pastewka/gpaw:latest
```

## Example

The file `diamond.py` contains a simple example that computes the energy of a 2x2x2 supercell of cubic diamond. Run it with:
```bash
apptainer run gpaw.sif gpaw python diamond.py
```

Or for parallel execution:
```bash
apptainer run gpaw.sif mpirun -np 4 gpaw python diamond.py
```

## Troubleshooting

### Performance issues

The container has a simple MPI benchmark installed. The exectuable is located at `/usr/local/bin/mpiBench`.

### Debugging libfabric issues

Set `FI_LOG_LEVEL=debug` before running the code.

### OMP: Error #179

If you get an error
```
OMP: Error #179: Function Can't open SHM2 failed:
OMP: System error #2: No such file or directory
```
you need to bind `/run/shm` into the container. Try executing:
```
OMP_NUM_THREADS=4 apptainer run --bind /run/shm:/run/shm gpaw.sif gpaw python script.py
```
