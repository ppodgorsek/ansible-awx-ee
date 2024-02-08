# Ansible AWX Execution Environment with AWS, Azure, GCP, Kubernetes, Helm, Java and Terraform

## What is it?

This project contains the configuration of an Ansible AWX Execution Environment container image with commonly used libraries.

It is based on the official Ansible AWX EE image and mainly includes:

* Cloud provider dependencies:

    * Amazon Web Services (AWS)
    * Google Cloud Platform (GCP)
    * Microsoft Azure

* Java 21
* Kubernetes & Helm
* PostgreSQL 16
* Terraform 1.7.3

## Versioning

The versioning of this project follows the one of the official Ansible AWX EE containers.

* If based on an existing AWX EE tag, the release will be the same as the EE one.
* If based on the latest EE tag, the release will have a `-SNAPSHOT` suffix to indicate the changing nature of the parent.

## AWX configuration

This image can be set up in AWX by:

1. Navigating to AWX > `Administration` > `Execution Environments`
2. Adding a new Execution Environment with the following details:

    * Name: `Custom AWX Execution Environment`
    * Image: `docker.io/ppodgorsek/ansible-awx-ee:latest`
    * Pull policy: `Only pull if not present before running`

3. Applying the execution environment on the relevant job templates.

## Installation details

In addition to using this image for AWX's execution environment, remember to define the list of Ansible Galaxy packages your project relies on in `/collections/requirements.yml`. That file has the following format:

    ---
    # Official documentation:
    # https://docs.ansible.com/ansible/devel/user_guide/collections_using.html
    
    collections:
    - collection1
    - collection2

In this example, `collection1` and `collection2` must of course be replaced by one of the values listed below.

Depending on your needs, the following collections are supported and can be added to the above file:

* Cloud providers:

    * [AWS](https://galaxy.ansible.com/amazon/aws): `amazon.aws`
    * [Azure](https://galaxy.ansible.com/azure/azcollection): `azure.azcollection`
    * [GCP](https://galaxy.ansible.com/google/cloud): `google.cloud`

* [Cryptography](https://galaxy.ansible.com/community/crypto): `community.crypto`
* [General](https://galaxy.ansible.com/community/general): `community.general`
* [Kubernetes](https://galaxy.ansible.com/kubernetes/core): `kubernetes.core`
* [PostgreSQL](https://galaxy.ansible.com/community/postgresql): `community.postgresql`
* [Terraform](https://galaxy.ansible.com/community/general): `community.general`

## Troubleshooting

### Job is not using the correct execution environment

Upon running a job, errors might appear which seem to be pointing to missing dependencies.

This is a common misconfiguration, remember to make sure your job templates are using the correct execution environment.

## Please contribute!

Have you found an issue? Do you have an idea for an improvement? Feel free to contribute by submitting it [on the GitHub project](https://github.com/ppodgorsek/ansible-awx-ee/issues).
