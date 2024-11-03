ARG BUILD_FROM=alpine:latest

FROM $BUILD_FROM
LABEL maintainer="Lukas Korl <hello@lukaskorl.com>"

RUN apk --update --no-cache add bash nfs-utils openssh && \
    # remove the default config files
    rm -v /etc/idmapd.conf /etc/exports

# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN mkdir -p /var/lib/nfs/rpc_pipefs                                                     && \
    mkdir -p /var/lib/nfs/v4recovery                                                     && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab && \
    echo "PasswordAuthentication yes"   >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes"       >> /etc/ssh/sshd_config && \
cat <<"EOM" > /etc/motd

       _  _   _____   _____ ___   _                 
    _ | |/ \ | _ \ \ / /_ _/ __| | |_  __ _ _  _ ___
   | || / _ \|   /\ V / | |\__ \_| ' \/ _` | || (_-<
    \__/_/ \_\_|_\ \_/ |___|___(_)_||_\__,_|\_,_/__/
  N F S   s e r v e r   o v e r   S S H   t u n n e l                                           

EOM

EXPOSE 2049

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
