# Introduction

These modules are built for creating the underlying cloud infrastructure on GCP for Cloud Private Edition.

## What is Infrastructure as code? 
Think about infrastructure as code as a scalable blueprint for your environment. It allows you to provision and configure your environments in a reliable and safe way. By using code to deploy your infrastructure you gain the ability to use the same tools as developers such as version control, testing, code reviews, and CI/CD. Infrastructure as code allows users to easily edit and distribute configurations while ensuring the desired state of the infrastructure. This means you can create reproducible infrastructure configurations.

# Prerequisites 

To deploy this project you can make use of the following tools:

## Install VS Code

Visual Studio Code is a fast source code editor. Visual Studio Code offers a Terriform extension that is maintained directly by Hashicorp (the creators of Terraform). It includes syntax highlighting, autocompletion and many more features making your experience better.

[Install VS Code here](https://code.visualstudio.com/download)

## Install Terraform

HashiCorp Terraform is a tool for building, changing, and versioning infrastructure that has an open-source and enterprise version. Terraform is cloud agnostic and can be used to create multi-cloud infrastructure. It allows Infrastructure as code in a human readable language called HashiCorp Configuration Language (HCL).

[Install Terraform here](https://learn.hashicorp.com/tutorials/terraform/install-cli)

If you already have a different version of terraform installed you can use this tool to manage differnt terraform versions on Mac and Linux: [tfenv](https://github.com/tfutils/tfenv)

For Windows, tfenv is not supported. You can download the required version(1.0.11) of terraform using the steps mentioned on the [official site](https://www.terraform.io/downloads).

For the this repository we are using terrform version `1.0.11`

## Install Google Cloud SDK

The Google Cloud SDK is used to interact with your GCP resources. Installation instructions for multiple platforms are available online.

[Install the Google Cloud SDK here](https://cloud.google.com/sdk/docs/install)

## Authenticate gcloud

Initialize, authorize, and configure the gcloud CLI:
``` bash
gcloud init
```

Ensure you have authenticated your gcloud client by running the following command:
``` bash
gcloud auth login
```
To acquire user credentials that will be used to create resources in gcp:
``` bash
gcloud auth application-default login
```

Confirm the gcloud configuration is pointing in the desired project with the following command:
``` bash
gcloud config set project my-project-name
```

 Make sure that compute/zone, compute/region are populated with values that work for you with the following commands:

 ``` bash
 gcloud config set compute/region us-east1
 ```
 ``` bash 
 gcloud config set compute/zone us-east1-c
 ```

# Modules Usage Steps

You can either create seperate terraform files to execute each module or you can create a branch from this repository and use the [Terraform Sample](./terraform/) files by replacing the dummy values. Once you are in the root folder for each terraform file, perform the following commands on the root folder to create or destroy the corresponding infrastructure:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

### Clone the repository and create branch

```bash
  $ git clone https://github.com/genesys/multicloud-platform.git
```

```bash
  $ git branch <new-branch-name> 
```


# Terraform Modules Overview

## 0-remotestate

This module supports:
- [Enabling the required APIs](https://cloud.google.com/apis/docs/overview)
- [Provisioning a GCP bucket for storing terraform state files](https://cloud.google.com/storage/docs/introduction)

## 1-network

This module supports creating the underlying networking setup needed for creating clusters within each region. Since these are all one-time configurations in each project, the example files are kept in a seperate directory called Global. The below resources are provisioned via this module:

- [VPC Network](https://cloud.google.com/vpc/docs)
- [Base DNS Zone](https://cloud.google.com/dns/docs/zones)
- [Subnets](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets)
- [Router](https://cloud.google.com/network-connectivity/docs/router/concepts/overview)
- [Nat Gateway](https://cloud.google.com/nat/docs/overview)

## 2-gke-cluster

This module supports creating a standard managed Google Kubernetes Engine zonal cluster (GKE) on public cloud. This module can be used for creating either linux or windows node pool based cluster.

- [Kubernetes Cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters)

## 3-k8s-setup

Since we create our own VPC, we cannot use the provided standard-rwx storage class which will only work with the default VPC. This module supports creating the a custom read-write-multiple(rwx) storage class.

- [Storage Class](https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes#storageclasses)

## 4-ingress-certs

For ingress-nginx we use cert-manager Helm chart along with a Let's Encrypt cluster-issuer to provide free rotating TLS certificates. This module supports creating the following resource. 

- [nginx-ingress](https://cloud.google.com/community/tutorials/nginx-ingress-gke)
- [cert-manager](https://cert-manager.io/docs/)
- [Let's encrypt](https://letsencrypt.org/getting-started/)


## 5-third-party
This module supports installing various third party applications that are used by Genesys services. These applications are installed using helm charts.

- [Kafka](https://github.com/confluentinc/cp-helm-charts)
- [Keda](https://github.com/kedacore/charts/tree/main/keda)
- [Consul](https://github.com/hashicorp/consul-k8s)

## 6-jumphost
This module supports creating a jumphost machine with IAP tunneling and corresponding firewall rules. It also creates a custom role for providing IAP access. Users can be given access to IAP using this module.

- [A Jumphost Instance](https://cloud.google.com/solutions/connecting-securely)
- [Firewall Rules required for Jumphost and IAP Tunneling](https://cloud.google.com/solutions/connecting-securely#firewalls)
- [Creating a custom IAM role for IAP access](https://cloud.google.com/iap/docs/using-tcp-forwarding#permission-details)
- [Assigning the custom role to members](https://cloud.google.com/iam/docs/permissions-reference)



## Additional information:
### helm/charts

Helm charts make it easy to deploy additional software on top of Kubernetes Clusters. Helm has a certain structure when you create a new chart. The directory structure looks like:

- **templates**: This is where Helm finds the YAML definitions for your Services, Deployments and other Kubernetes objects. They will all get their values from values.yaml from below.
- **.helmignore**: This holds all the files to ignore when packaging the chart.
- **Chart.yaml**: This file contains a description of the chart. 
- **values.yaml**: This is where you define all the values you want to inject into your templates.