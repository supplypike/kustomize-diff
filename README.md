# GitHub Action for Kustomize Build+Diff

Example Usage
```yaml
name: kustomize-diff
on:
  pull_request:
jobs:
  kustomize-diff:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    - uses: supplypike/kustomize-diff@v1
      id: kustdiff
      with:
        kustomizations: |-
          .kustomization/staging
          .kustomization/production
    - uses: mshick/add-pr-comment@v2
      with:
        message: ${{ steps.kustdiff.outputs.diff }}
```