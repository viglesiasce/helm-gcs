# helm-gcs
Helm plugin for using Google Cloud Storage as a private chart repository.

## THIS IS NOT AN OFFICIAL GOOGLE PRODUCT

## Install

1. Ensure the Google Cloud SDK is installed. This plugin depends on `gsutil`.

1. Authenticate the Google Cloud SDK.

    ```shell
    $ gcloud auth login
    ```

1. Install the Helm plugin

    ```shell
    $ helm plugin install https://github.com/viglesiasce/helm-gcs.git --version v0.1.0
    ```

## Usage

1. Create a new Cloud Storage bucket:

    ```shell
    $ export PROJECT=$(gcloud info --format='value(config.project)') 
    $ gsutil mb gs://$PROJECT-helm-repo
    ```

1. Initialize an existing Cloud Storage Bucket to be a Helm repo:

    ```shell
    $ helm gcs init gs://$PROJECT-helm-repo
    ```

1. Create a test chart and package it:

    ```shell
    $ helm create test-chart
    $ helm package test-chart
    ```
    
1. Upload the chart to your repository:

    ```shell
    $ helm gcs push test-chart-0.1.0.tgz gs://$PROJECT-helm-repo
    ```
    
1. Add your Cloud Storage repo into your local Helm client:

    ```shell
    $ helm repo add gcs-repo gs://$PROJECT-helm-repo
    ```
    
1. List the charts in your newly added repo:

    ```shell
    $ helm search gcs-repo
    NAME               	VERSION	DESCRIPTION                
    gcs-repo/test-chart	0.1.0  	A Helm chart for Kubernetes
    ```
