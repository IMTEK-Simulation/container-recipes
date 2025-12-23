# CASTEP *under construction*

You will need to have received a CASTEP-25.12.tar.gz archive that contains the software. This is accesible only for licensees.

## Docker

This directory contains a Docker recipe that builds [CASTEP](https://www.castep.org/) 25.12 with the Intel oneAPI HPC Toolkit. 

Build the Docker image with:
```bash
docker build -t castep-25.12 .
```

The image is kept local because of licensing reasons. You need the CASTEP install files.

## Apptainer

The Docker images can be converted into an Apptainer image for use on HPC systems. Convert the image with:
```bash
apptainer build castep-25.12.sif docker-daemon://castep-25.12:latest
```
## Example

## Troubleshooting

### Performance issues
