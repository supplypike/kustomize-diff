FROM debian:bookworm-slim

COPY entrypoint.sh .

ENTRYPOINT [ "./entrypoint.sh" ]