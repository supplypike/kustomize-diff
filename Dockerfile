FROM registry.k8s.io/kustomize/kustomize:v5.0.0

RUN apk add --no-cache \
	sed \
	diffoscope

COPY entrypoint.sh .
ENTRYPOINT [ "./entrypoint.sh" ]