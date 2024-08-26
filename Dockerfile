# FROM debian:bookworm-slim

# ARG TARGETOS
# ARG TARGETARCH
# ARG KUSTOMIZE_VERSION=5.4.3

# RUN apt-get -yqq update \
# 	&& apt-get -yqq install --no-install-recommends \
# 	bash \
# 	curl \
# 	git \
# 	ca-certificates \
# 	&& rm -rf /var/lib/apt/lists/*

# RUN curl -fL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz | tar xz -C /usr/local/bin

# COPY entrypoint.sh .
# ENTRYPOINT [ "./entrypoint.sh" ]

FROM registry.k8s.io/kustomize/kustomize:v5.0.0

COPY entrypoint.sh .
ENTRYPOINT [ "./entrypoint.sh" ]