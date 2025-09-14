FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl iproute2 iputils-ping && rm -rf /var/lib/apt/lists/*
CMD ["/bin/bash", "-c", "while true; do sleep 3600; done"] 
