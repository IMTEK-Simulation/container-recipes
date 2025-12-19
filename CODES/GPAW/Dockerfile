#
# Docker image for GPAW with Intel oneAPI compilers
#

FROM intel/hpckit:latest

RUN apt-get update -y \
	&& apt-get install -y \
	curl \
	git \
	python3 \
	python3-pip \
	python3-venv \
	&& rm -rf /var/lib/apt/lists/*

#
# Install libxc
#

ENV LIBXC_VERSION="7.0.0"
WORKDIR /tmp
RUN curl -L https://gitlab.com/libxc/libxc/-/archive/${LIBXC_VERSION}/libxc-${LIBXC_VERSION}.tar.bz2 | tar -xj
WORKDIR /tmp/libxc-${LIBXC_VERSION}
RUN mkdir build && cd build \
    && cmake -DCMAKE_C_COMPILER=icx -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON .. \
    && make \
    && make test \
    && make install

# Add /usr/local/lib to library path for libxc
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

# Install GPAW - Python module and standalone code
# ASE 3.26.0 belongs to GPAW 25.7.0 - see https://wiki.fysik.dtu.dk/gpaw/releasenotes.html
ENV ASE_VERSION=3.26.0
RUN python3 -m pip install --upgrade pip \
	&& python3 -m pip install ase==${ASE_VERSION} \
	&& python3 -m pip install mpi4py matscipy
ENV GPAW_VERSION=25.7.0
WORKDIR /tmp
RUN echo 'mpicompiler="mpiicx"' > gpaw_siteconfig.py \
	&& echo 'libraries =["xc", "mkl_rt", "pthread", "m"]' >> gpaw_siteconfig.py \
	&& LANG=C.UTF-8 GPAW_CONFIG=/tmp/gpaw_siteconfig.py python3 -m pip -v install gpaw==${GPAW_VERSION}

# Install simple MPI benchmark
WORKDIR /tmp
RUN git clone https://github.com/LLNL/mpiBench.git \
	&& cd mpiBench \
	&& make \
	&& cp mpiBench /usr/local/bin

# Get GPAW setups
ENV GPAW_SETUPS_VERSION="24.11.0"
RUN mkdir -p /usr/local/share \
	&& curl -L https://wiki.fysik.dtu.dk/gpaw-files/gpaw-setups-${GPAW_SETUPS_VERSION}.tar.gz | tar -xzC /usr/local/share

# Set environment variable for GPAW setups
ENV GPAW_SETUP_PATH=/usr/local/share/gpaw-setups-${GPAW_SETUPS_VERSION}

# Just make sure there is no OpenMP madness goingon
ENV OMP_NUM_THREADS=1
ENV MKL_NUM_THREADS=1

CMD ["python3"]
