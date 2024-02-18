FROM rockylinux/rockylinux:8.7

# Install required packages
RUN dnf install -y wget tar gzip

# Download and install Go
ENV GOLANG_VERSION=1.22.0
RUN wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    rm go${GOLANG_VERSION}.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

# Install Delve (dlv) server
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Expose the required ports for Delve
EXPOSE 2345
 
# Set the work directory
WORKDIR /app
RUN echo $(pwd)
RUN echo $(ls -la)
COPY ./build/myApp /app/

# Start the Delve server
CMD ["dlv", "exec", "--listen=:2345", "--headless=true", "--api-version=2", "--log", "myApp"]