# CASTEP *under construction*

## Docker

This directory contains a Docker recipe that builds [CASTEP](https://www.castep.org/) 25.12 with the Intel oneAPI HPC Toolkit. 

Build the Docker image with:
```bash
docker build -t castep-25.2 .
```

The image is kept local. You need the CASTEP install files.

## Apptainer

The Docker images can be converted into an Apptainer image for use on HPC systems. Convert the image with:
```bash
apptainer build gpaw.sif docker-daemon://gpaw:latest
```

## Docker Hub

The image is not available on [Docker Hub](https://hub.docker.com) (see Docker). 

## Example

## Troubleshooting

### Performance issues
