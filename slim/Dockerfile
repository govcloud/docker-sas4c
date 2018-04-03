FROM centos:7

LABEL maintainer "William Hearn <william.hearn@canada.ca>"

ENV container=docker

ARG AZURE_ACCOUNT_NAME=statcan
ENV ACCOUNT_NAME=${AZURE_ACCOUNT_NAME}

ARG AZURE_ACCOUNT_KEY
ENV ACCOUNT_KEY=${AZURE_ACCOUNT_KEY}

RUN yum -y install bsdtar \
                   numactl-libs.x86_64 \
                   libXp \
                   passwd \
                   libpng12 \
                   libXmu.x86_64 \
                   vim \
                   which && \
                   ln -sf $(which bsdtar) $(which tar)

RUN useradd -m sas && \
    groupadd -g 1001 sasstaff && \
    usermod -a -G sasstaff sas && \
    echo -e "sas" | /usr/bin/passwd --stdin sas

RUN curl -L https://github.com/Azure/blobporter/releases/download/v0.6.12/bp_linux.tar.gz -o /tmp/blobporter.tar.gz && \
    tar -xf /tmp/blobporter.tar.gz -C /tmp linux_amd64/blobporter && \
    mv /tmp/linux_amd64/blobporter /usr/local/bin/blobporter && \
    rm -rf /tmp/* && \
    chmod a+x /usr/local/bin/blobporter

ADD scripts/* /

RUN cd /usr/local/ && \
    blobporter -c sas -n SASHomeSlim.tar -t blob-file && \
    tar -xf SASHomeSlim.tar && \
    rm SASHomeSlim.tar && \
    chown -R sas:sasstaff /usr/local/SASHome && \
    ln -s /usr/local/SASHome/SASFoundation/9.4/bin/sas_en /usr/local/bin/sas

WORKDIR /home/sas

ENV PATH=$PATH:/usr/local/SASHome/SASFoundation/9.4/bin

ENV PATH=$PATH:/usr/local/SASHome/SASPrivateJavaRuntimeEnvironment/9.4/jre/bin

EXPOSE 38080

ENTRYPOINT ["/bin/bash"]
CMD ["/start.sh"]
