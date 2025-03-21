# docker-cuda-sshd

This is a CUDA Docker image that supports SSH login. After you run a container with it, you can perform remote development via SSH.

## Quick Start

Build image

```bash
git clone https://github.com/haowang02/docker-cuda-sshd
cd docker-cuda-sshd
docker build -t cuda-sshd:12.1.0-cudnn8-devel-ubuntu22.04 .
```

Run container

```bash
docker run -d \
    --runtime=nvidia \
    --name={username} \
    --restart=always \
    --privileged \
    --shm-size=128gb \
    --cpus=64 \
    -p {port}:22 \
    -v /data/homes/{username}:/home/{username} \
    --gpus=all \
    -e ROOT_PASSWORD={root_password} \
    -e USERNAME={username} \
    -e USER_PASSWORD={user_password} \
    cuda-sshd:12.1.0-cudnn8-devel-ubuntu22.04
```

SSH login

```bash
ssh {username}@127.0.0.1 -p {port}
```