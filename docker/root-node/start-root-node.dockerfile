FROM golang:buster as builder

# RUN apk add --no-cache jq make bash g++

RUN apt update

RUN apt install -y jq build-essential

WORKDIR /usr/cudos-builder

COPY ./CudosNode ./

RUN make

# CMD ["sleep", "infinity"]

FROM golang:buster

WORKDIR /usr/cudos

# RUN apk add --no-cache bash

COPY --from=builder /go/pkg/mod/github.com/!cosm!wasm/wasmvm@v0.14.0/api/libwasmvm.so /usr/lib

COPY --from=builder /go/bin/cudos-noded /go/bin/cudos-noded

CMD ["/bin/bash", "-c", "cudos-noded start"] 