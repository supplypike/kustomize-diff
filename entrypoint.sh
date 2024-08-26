#!/bin/sh

set -x

echo "Hello World"
echo "head $INPUT_HEAD_REF base $INPUT_BASE_REF"

echo "diff=foo" >>"$GITHUB_OUTPUT"

exit 0
