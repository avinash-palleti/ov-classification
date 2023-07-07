FROM docker.io/ubuntu:20.04 AS builder

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Update the package lists and install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Pipenv
RUN pip3 install --no-cache-dir --user pipenv

# Set environment variables for Pipenv
ENV PATH="/root/.local/bin:${PATH}"
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_IGNORE_VIRTUALENVS=1

WORKDIR /dlwb/openvino_2022.3.0

# Copy and install with pipenv
# manually remove opencv-python to default to headless version instead
COPY Pipfile .
COPY Pipfile.lock .
RUN pipenv install --deploy \
    && pipenv uninstall opencv-python \
    && pipenv clean

FROM docker.io/ubuntu:20.04

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Update the package lists and install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install GPU Drivers https://github.com/intel/compute-runtime/releases
WORKDIR /neo
RUN apt-get update && apt-get install -y --no-install-recommends wget ocl-icd-libopencl1 \
    && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.13700.14/intel-igc-core_1.0.13700.14_amd64.deb \
    && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.13700.14/intel-igc-opencl_1.0.13700.14_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-level-zero-gpu-dbgsym_1.3.26032.30_amd64.ddeb \
    && wget https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-level-zero-gpu_1.3.26032.30_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-opencl-icd-dbgsym_23.13.26032.30_amd64.ddeb \
    && wget https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-opencl-icd_23.13.26032.30_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/libigdgmm12_22.3.0_amd64.deb \
    && dpkg -i *.deb \
    && ldconfig \
    && rm -rf /neo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy envr.
COPY --from=builder /dlwb/openvino_2022.3.0 /dlwb/openvino_2022.3.0

# Copy jobs and replace with venv path in container
# /data is already used for mounts and alternate path is required
#COPY jobs /dlwb/jobs
#RUN find /dlwb/jobs -type f -exec sed -i 's#source /data/venv/openvino_2022.3.0/.venv/bin/activate#source /dlwb/openvino_2022.3.0/.venv/bin/activate#g' {} +

WORKDIR /app
COPY fruit-and-vegetable-detection.mp4 .
COPY imagenet_2012.txt .
COPY imagenet_2015.txt .
RUN wget https://github.com/openvinotoolkit/open_model_zoo/archive/refs/tags/2022.3.0.tar.gz \
    && tar -xvf 2022.3.0.tar.gz \
    && rm -rf 2022.3.0.tar.gz \
    && . /dlwb/openvino_2022.3.0/.venv/bin/activate \
    && pip3 install opencv-python-headless==4.5.3.56

WORKDIR /data

ENV MODEL=""
ENV DEVICE=CPU
ENV INPUT=/app/fruit-and-vegetable-detection.mp4
ENV LABELS=/app/imagenet_2012.txt
ENV OUTPUT=/data/result.avi

ENTRYPOINT ["/bin/bash", "-c", "source /dlwb/openvino_2022.3.0/.venv/bin/activate && python3 /app/open_model_zoo-2022.3.0/demos/classification_demo/python/classification_demo.py -m ${MODEL} -i ${INPUT} --labels ${LABELS} --no_show -d ${DEVICE} -o ${OUTPUT} && sleep 3"]