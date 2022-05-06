# Infrastructure
The infrastructure that runs the mindtastic backend

## Setup

### Requirements

    brew install --cask google-cloud-sdk
    brew install terraform

## To run

First, authenticate with Google Cloud

    terraform init
    terraform plan
    terraform destroy

## To test

Exchange variable "google_container_cluster"
