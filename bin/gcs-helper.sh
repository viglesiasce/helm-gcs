#!/bin/bash -e

function usage() {
  if [[ ! -z "$1" ]]; then
    printf "$1\n\n"
  fi
  cat <<'  EOF'
  Helm plugin for using Google Cloud Storage as a private chart repository

  To begin working with helm-gcs plugin, authenticate gcloud

    $ gcloud auth login

  Usage:
    helm gcs init [BUCKET_URL]
    helm gcs push [CHART_FILE] [BUCKET_URL]

  Available Commands:
    init    Initialize an existing Cloud Storage Bucket to a Helm repo
    push    Upload the chart to your bucket

  Example:

    $ helm gcs init gs://my-unique-helm-repo-bucket-name
    $ helm gcs push my-chart-0.1.0.tgz gs://my-unique-helm-repo-bucket-name

  EOF
}

COMMAND=$1

case $COMMAND in
init)
  BUCKET=$2
  if [[ -z "$2" ]]; then
    usage "Error: Please provide a bucket URL in the format gs://BUCKET"
    exit 1
  else
    gsutil cp -n $HELM_PLUGIN_DIR/etc/index.yaml $BUCKET
    echo "Repository initialized..."
    exit 0
  fi
  ;;
push)
  if [[ -z "$2" ]] || [[ -z "$3" ]]; then
    usage "Error: Please provide chart file and/or bucket URL in the format gs://BUCKET"
    exit 1
  fi
  CHART_PATH=$2
  BUCKET=$3
  TMP_DIR=$(mktemp -d)
  TMP_REPO=$TMP_DIR/repo
  OLD_INDEX=$TMP_DIR/old-index.yaml

  gsutil cat $BUCKET/index.yaml > $OLD_INDEX
  mkdir $TMP_REPO
  cp $CHART_PATH $TMP_REPO
  helm repo index --merge $OLD_INDEX --url $BUCKET $TMP_REPO
  gsutil cp $TMP_REPO/index.yaml $BUCKET
  gsutil cp $TMP_REPO/$(basename $CHART_PATH) $BUCKET
  echo "Repository initialized..."
  ;;
*)
  usage
  ;;
esac