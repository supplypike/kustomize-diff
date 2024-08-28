#!/bin/sh

set -eux

build_dir=$(mktemp -d)

echo $INPUT_KUSTOMIZATIONS

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

build "$INPUT_BASE_REF"
build "$INPUT_HEAD_REF"

base_ref_build_dir="$build_dir/$INPUT_BASE_REF"
head_ref_build_dir="$build_dir/$INPUT_HEAD_REF"

set +e
for target in $INPUT_KUSTOMIZATIONS; do
	diffoscope "$base_ref_build_dir/$target" "$head_ref_build_dir/$target" \
		--markdown - \
		--exclude-directory-metadata=yes | tee -a diff.md
done

set -e

# Formatting hacks
output=$(cat diff.md | sed "s|$base_ref_build_dir/||" | sed '/Comparing/ s/&.*$//' | sed "s|^#\{2,\} Comparing| Comparing|" | sed "s|^# Comparing|## Comparing|")

{
	echo 'diff<<EOF'
	echo "$output"
	echo 'EOF'
} >>"$GITHUB_OUTPUT"

exit 0
