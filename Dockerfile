# Use an NVIDIA CUDA base image with Ubuntu 20.04 as the foundation
FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# Set environment variables to avoid user interaction during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.9 and other essential build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3-pip \
    curl \
    build-essential \
    git \
    libopenexr-dev \
    libxi-dev \
    libglfw3-dev \
    libglew-dev \
    libomp-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxrandr-dev \
    cuda-toolkit-11-0 \
    && ln -s /usr/bin/python3.9 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Manually install a newer version of CMake
RUN cd /tmp \
    && curl -LO https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.sh \
    && chmod +x cmake-3.22.1-linux-x86_64.sh \
    && ./cmake-3.22.1-linux-x86_64.sh --prefix=/usr/local --skip-license \
    && rm cmake-3.22.1-linux-x86_64.sh

# Upgrade pip to the latest version
RUN pip install --no-cache-dir --upgrade pip

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY . /app/

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Build the code
RUN cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    && cmake --build build --config RelWithDebInfo -j 

# The command to run when the container starts
CMD ["python"]

