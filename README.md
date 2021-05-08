# Terraform Kubernetes on Digital Ocean

This repository contains the Terraform module for creating a Kubernetes Cluster on Digital Ocean.

<p align="center">
<img alt="Digital Ocean Logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/DigitalOcean_logo.svg/240px-DigitalOcean_logo.svg.png">
</p>


- [Terraform Kubernetes on Digital Ocean](#Terraform-Kubernetes-on-Digital-Ocean)
- [Requirements](#Requirements)
- [Features](#Features)
- [Notes](#Notes)
- [Defaults](#Defaults)
- [Runtime](#Runtime)
- [Terraform Inputs](#Terraform-Inputs)
- [Outputs](#Outputs)

## Requirements

You need a [Digital Ocean account] and a [Personal access token](https://cloud.digitalocean.com/account/api/tokens).
set the environment variable DIGITALOCEAN_TOKEN with the token


## Features

* Kubernetes default version 1.20.2-do.0 on Digital Ocean
* Kubernetes Cluster with 1 + 2 = *3* worker nodes (default node pool + additional node pool)
* **kubeconfig** file generation at completion


## Notes

* The resources will be created in your default Digital Ocean project
* If you want to add/remove worker nodes, just edit the `do_k8s_nodepool_size` variable
* It can take 2-3 minutes after Terraform completes until the Kubernetes nodes are available
* `export KUBECONFIG=./kubeconfig_do` in repo root dir to use the generated kubeconfig file
* The `enable_digitalocean` is used in the hajowieland/terraform-kubernetes-multi-cloud module

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.


* Default region: **nyc1** _(New York, United States)_
* Default Kubernetes version: **1.20.2-do.0**
* Default Node type: **s-1vcpu-2gb** _(1x vCPU, 2GB memory)_
* Default main pool size: **1**
* Default additional node pool size: **2**


## Steps

terraform init
env=dev
terraform workspace new ${env}
terraform plan -out=./plans/tf_${env}_plan
terraform apply "./plans/tf_${env}_plan" -auto-approve


## To remove the infrastructure
## The terraform destroy command terminates resources managed by your Terraform project

env=dev
terraform workspace select ${env}
terraform plan -destroy -out=./plans/tf_${env}_destroy
terraform apply ./plans/tf_${env}_destroy

## Terraform Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable_digitalocean | Enable / Disable Digital Ocean | bool | true | yes |
| random_cluster_suffix | Random 6 byte hex suffix for cluster name | string |  | yes |
| do_k8s_nodes | Worker nodes | int | 2 | yes |
| do_token | Digital Ocean Personal access token | string | DUMMY | **yes** |
| do_region | Digital Ocean region | string | nyc1 | yes |
| do_k8s_name | Digital Ocean Kubernetes cluster name | string | k8s-do | yes |
| do_k8s_version | Digital Ocean Kubernetes version | string | 1.20.2-do.0 | yes |
| do_k8s_pool_name | Digital Ocean Kubernetes default node pool name | string | k8s-nodepool-do | yes |
| do_k8s_nodes | Digital Ocean Kubernetes default node pool size | number | 1 | yes |
| do_k8s_node_type | Digital Ocean Kubernetes default node pool type | string | s-1vcpu-2gb | yes |
| do_k8s_nodepool_type | Digital Ocean Kubernetes additional node pool type | string | s-1vcpu-2gb | yes |
| do_k8s_nodepool_size | Digital Ocean Kubernetes additional node pool size | number | 2 | yes |




## Outputs

| Name | Description |
|------|-------------|
| kubeconfig_path_do | Kubernetes kubeconfig file |
