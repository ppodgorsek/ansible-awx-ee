# The source of the parent container can be found here:
# https://github.com/ansible/awx-ee

FROM quay.io/ansible/awx-ee:23.7.0

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Ansible AWX Execution Environment container with Cloud providers, Terraform, Kubernetes and other common tools.

ENV ANSIBLE_COLLECTION_AWS_VERSION     8.1.0
ENV ANSIBLE_COLLECTION_AZURE_VERSION   v1.19.0
ENV ANSIBLE_COLLECTION_GCP_VERSION     v1.3.0
ENV HELM_VERSION                       v3.14.0
ENV JAVA_VERSION                       21
ENV POSTGRESQL_VERSION                 16
ENV TERRAFORM_VERSION                  1.7.3

USER root

# Install build dependencies
RUN dnf upgrade -y > /dev/null \
  && dnf install -y \
    java-${JAVA_VERSION}-openjdk \
    openssl \
    unzip \
    > /dev/null \
  && dnf clean all

# Cloud: Amazon Web Services (AWS)
RUN pip3 install -r https://raw.githubusercontent.com/ansible-collections/amazon.aws/${ANSIBLE_COLLECTION_AWS_VERSION}/requirements.txt

# Cloud: Azure
RUN pip3 install -r https://raw.githubusercontent.com/ansible-collections/azure/${ANSIBLE_COLLECTION_AZURE_VERSION}/requirements-azure.txt

# Cloud: Google Cloud Platform (GCP)
RUN pip3 install -r https://raw.githubusercontent.com/ansible-collections/google.cloud/${ANSIBLE_COLLECTION_GCP_VERSION}/requirements.txt

# Cryptography
RUN pip3 install cryptography

# Kubernetes & Helm
COPY conf/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN dnf install -y kubectl \
  && dnf clean all
RUN pip3 install kubernetes
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/${HELM_VERSION}/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh --version ${HELM_VERSION} \
  && rm -f get_helm.sh \
  && helm plugin install https://github.com/databus23/helm-diff

# PostgreSQL
RUN dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
  && dnf -qy module disable postgresql \
  && dnf install -y postgresql${POSTGRESQL_VERSION} \
  && dnf clean all
RUN pip3 install psycopg2-binary

# Terraform
# Official documentation: https://developer.hashicorp.com/terraform/install
RUN yum install -y yum-utils \
  && yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
  && yum install -y terraform \
  && yum clean all

# Fix a bug in the runner's home directory
RUN chown -R 1000:1000 /runner

# Drop back to the regular user (good practice)
USER 1000
