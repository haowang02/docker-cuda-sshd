#!/bin/bash -eu
CONTAINER_ALREADY_STARTED="/usr/local/bin/container_already_started"

# only run on first start
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    # set timezone
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
    echo ${TZ} > /etc/timezone
    echo "root:${ROOT_PASSWORD}" | chpasswd
    # create user
    # considering that the user's home directory may be mounted through -v, 
    # so the useradd command cannot directly create the home directory
    if [ ! -d /home/${USERNAME} ]; then
        mkdir -p /home/${USERNAME}
    fi
    useradd -s /bin/bash -d /home/${USERNAME} -G sudo ${USERNAME}
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
    cp -r /etc/skel/. /home/${USERNAME}
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
fi

# start sshd
echo "Starting sshd..."
exec /usr/sbin/sshd -D