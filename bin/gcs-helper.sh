#!/bin/bash -e
COMMAND=$1

case $COMMAND in
init)
  BUCKET=$2
  if [[ -z "$2" ]];then
    echo "Please provide a bucket URL in the format gs://BUCKET"
    exit 1
  else
    gsutil cp -n $HELM_PLUGIN_DIR/etc/index.yaml $BUCKET
    echo "Repository initialized..."
    exit 0
  fi
  ;;
push)
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
  # TODO turn this into usage()
  echo "Please provide a command."
  ;;
esac