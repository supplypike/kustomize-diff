#!/bin/sh

set -eux

build_dir=$(mktemp -d)

build() {
	ref="$1"
	git checkout "$1" --quiet

	for target in $INPUT_KUSTOMIZATIONS; do
		echo "Building $target" to "$build_dir/$ref/$target"
		mkdir -p "$build_dir/$ref/$target"
		kustomize build "$target" -o "$build_dir/$ref/$target/"
	done
}

git config --global --add safe.directory "$GITHUB_WORKSPACE"

build $INPUT_BASE_REF
build $INPUT_HEAD_REF

diff="$(git diff --no-index "$build_dir/$INPUT_BASE_REF" "$build_dir/$INPUT_HEAD_REF")"
escaped_output=$diff # TODO Escape output

# If escaped output is longer than 65000 characters return "output to large to print as a github comment"
if [ ${#escaped_output} -gt 65000 ]; then
	escaped_output="Output is greater than 65000 characters, and therefore too large to print as a github comment."
fi

echo "diff=$escaped_output" >>"$GITHUB_OUTPUT"
exit 0
