---
page_type: sample
languages:
- javascript
products:
- azure
description: "This Node.js application is for use in demonstrating scenarios for Azure Container Registry Tasks."
urlFragment: acr-build-helloworld-node
---


# ACR Build Hello World

This Node.js application is for use in demonstrating scenarios for Azure Container Registry Tasks. [ACR Tasks](https://docs.microsoft.com/azure/container-registry/container-registry-tasks-overview) is a suite of features within [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) for performing Docker container builds on [Azure](https://azure.com), as well as automated OS and framework patching for Docker containers.

## Features

This project includes the following Dockerfiles:

* *Dockerfile* - Non-parameterized Dockerfile for building the application. References a base image in Docker Hub.
* *Dockerfile-app* - Parameterized, accepts the `REGISTRY_NAME` argument to specify the FQDN of the container registry from which the base image is pulled.
* *Dockerfile-base* - Defines a base image for the application defined in *Dockerfile-app*.

This project also includes the following YAML files:

* *taskmulti.yaml* - Specifies a multistep task to build, run, and push a container image specified by *Dockerfile*.
* *taskmulti-multiregistry.yaml* - Specifies a multistep task to build, run, and push container images specified by *Dockerfile* to multiple registries.

## Manage base images in private registry

The Dockerfile(s) in this sample reference base images pulled from public sources such as Docker Hub.

To reduce dependencies on public content, we recommend that you maintain copies of base images in a private registry such as Azure Container Registry. Then, update each Dockerfile to pull the base image from your private registry. 

1. If you don't already have a private registry, [create an Azure container registry](../container-registry/container-registry-get-started-portal.md) in your Azure subscription. When using the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli):

    ```

    # Log in to Azure CLI
    az login

    # Create resource group in Azure region. Example: eastus
    az group create --name myResourceGroup --location eastus

    # Create container registry with unique name in Standard tier
    az acr create -name myregistry --group myResourceGroup --sku Standard
    ```

1. Import the base image to your registry using the `az acr import` command The following example pulls a `node:15-alpine` base image from Docker Hub. 

    Use your Docker Hub credentials and substitute the base image referenced in this sample's Dockerfile:
    ```
    BASE_IMAGE=node:15-alpine

    az acr import \
      --name myregistry \
      --source docker.io/library/$BASE_IMAGE \
      --image $BASE_IMAGE \
      --username <Docker Hub username> \
      --password <Docker Hub password or token>
    ```

1. Update the Dockerfile to reference the base image in the private registry. In the sample, update the `ARG` statement with the fully qualified registry URL, such as *myregistry.azurecr.io/*, including the `/` at the end:
    ```azurecli
    ARG REGISTRY_FROM_URL=myregistry.azurecr.io/
    FROM ${REGISTRY_FROM_URL}<base image:tag>
    [...]
    ```

1. Log in to the private registry before building the image. For example:
    ```
    az acr login
    ```  
    
    See additional [authentication options](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication).

## Getting Started

### Companion articles

This project is intended for use with the following articles on [docs.microsoft.com][docs]:

* [Build container images in the cloud with Azure Container Registry Tasks][build-quick]
* [Automate container image builds in the cloud when you commit source code][build-task]
* [Run a multi-step container workflow in the cloud when you commit source code][multi-step]
* [Automate container image builds when a base image is updated in an Azure container registry][build-base]

### Quickstart

Although intended for use with the companion articles, you can perform the following steps to run the sample application. These steps require a local [Docker](http://docker.com) installation.

1. `git clone https://github.com/Azure-Samples/acr-build-helloworld-node`
1. `cd acr-build-helloworld-node`
1. `docker build -t helloacrbuild:v1 .`
1. `docker run -d -p 8080:80 helloacrbuild:v1`
1. Navigate to http://localhost:8080 to view the running application

## Resources

[Azure Container Registry](https://azure.microsoft.com/services/container-registry/)

[Azure Container Registry documentation](https://docs.microsoft.com/azure/container-registry/)

<!-- LINKS - External -->
[build-quick]: https://docs.microsoft.com/azure/container-registry/container-registry-tutorial-quick-build
[build-task]: https://docs.microsoft.com/azure/container-registry/container-registry-tutorial-build-task
[build-base]: https://docs.microsoft.com/azure/container-registry/container-registry-tutorial-base-image-update
[multi-step]: https://docs.microsoft.com/azure/container-registry/container-registry-tutorial-multistep-task
[docs]: http://docs.microsoft.com
