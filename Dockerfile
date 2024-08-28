FROM registry.k8s.io/kustomize/kustomize:v5.0.0

RUN apk add --no-cache \
	sed \
	diffoscope

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]