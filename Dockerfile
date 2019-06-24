FROM centos:7
LABEL maintainer "William Hearn <william.hearn@canada.ca>"
LABEL site="https://www.sas.com"

ARG AZURE_ACCOUNT_NAME=jupyter
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

# BlobPorter
RUN curl -L https://github.com/Azure/blobporter/releases/download/v0.6.20/bp_linux.tar.gz -o /tmp/blobporter.tar.gz && \
    tar -xf /tmp/blobporter.tar.gz -C /tmp linux_amd64/blobporter && \
    mv /tmp/linux_amd64/blobporter /usr/local/bin/blobporter && \
    rm -rf /tmp/* && \
    chmod a+x /usr/local/bin/blobporter

RUN cd /usr/local/ && \
    blobporter -c sas -n SASHome-Studio-20190620.tgz -t blob-file && \
    tar -xzpf SASHome-Studio-20190620.tgz && \
    rm SASHome-Studio-20190620.tgz && \
    chown -R sas:sasstaff /usr/local/SASHome && \
    ln -s /usr/local/SASHome/SASFoundation/9.4/bin/sas_en /usr/local/bin/sas

ADD scripts/* /

WORKDIR /home/sas

ENV PATH=$PATH:/usr/local/SASHome/SASFoundation/9.4/bin

ENV PATH=$PATH:/usr/local/SASHome/SASPrivateJavaRuntimeEnvironment/9.4/jre/bin

RUN /usr/local/SASHome/SASFoundation/9.4/utilities/bin/setuid.sh

ENV SAS_HADOOP_JAR_PATH=/opt/hadoop

EXPOSE 8561 8591 38080

ENTRYPOINT ["/bin/bash"]

CMD ["/start.sh"]
