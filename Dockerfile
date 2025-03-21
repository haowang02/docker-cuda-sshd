FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04
LABEL maintainer="Hao Wang"
LABEL description="CUDA docker image with SSH support"
LABEL version="1.0.0"

COPY ./sources.list /etc/apt/sources.list

# install packages
RUN rm -rf /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata sudo locales openssh-server \
    && apt clean

# allow root login
RUN mkdir /run/sshd \
    && sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config \
    && sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config

# set locale
RUN sed -i '/^# en_US.UTF-8/s/^# //' /etc/locale.gen \
    && sed -i '/^# zh_CN.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen

# entrypoint
COPY ./entry_point.sh /usr/local/bin/entry_point.sh
RUN chmod +x /usr/local/bin/entry_point.sh

ENV TZ=Asia/Shanghai
ENV ROOT_PASSWORD=ZtuuK3jDDj7X2E8bqvEy   # change this to your own password
ENV USERNAME=user                        # change this to your own username
ENV USER_PASSWORD=ZtuuK3jDDj7X2E8bqvEy   # change this to your own password
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entry_point.sh"]