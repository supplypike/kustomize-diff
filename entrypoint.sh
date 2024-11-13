#!/bin/sh

set -eux

build_dir=$(mktemp -d)

build_base() {
	ref="$INPUT_BASE_REF"
	git checkout "$ref" --quiet

	for target in $INPUT_KUSTOMIZATIONS; do
		echo "Building base $target" to "$build_dir/$ref/$target"
		mkdir -p "$build_dir/$ref/$target"
		if [ ! -d "$target" ]; then
			echo "Base $target does not exist. Treating it as an empty dir"
			mkdir -p "$target"
		else
			kustomize build "$target" -o "$build_dir/$ref/$target/"
		fi
	done
}

build_head() {
	ref="$INPUT_HEAD_REF"
	git checkout "$ref" --quiet

	for target in $INPUT_KUSTOMIZATIONS; do
		echo "Building head $target" to "$build_dir/$ref/$target"
		mkdir -p "$build_dir/$ref/$target"
		kustomize build "$target" -o "$build_dir/$ref/$target/"
	done
}

git config --global --add safe.directory "$GITHUB_WORKSPACE"

build_base
build_head

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

if [ ${#output} -gt 65535 ]; then
	output="Kustomize diff too large to display"
fi

if [ -z "$output" ]; then
	output="Kustomize diff did not find any differences"
fi

{
	echo 'diff<<EOF'
	echo "$output"
	echo 'EOF'
} >>"$GITHUB_OUTPUT"

exit 0
