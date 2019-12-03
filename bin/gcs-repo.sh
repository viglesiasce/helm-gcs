#!/bin/bash
REPO=${4/https:/gs:}
REPO=${REPO/\.storage\.googleapis\.com/""}
gsutil cat $REPO
exit 0
