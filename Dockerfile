# FROM - Defines a base image, it can be pulled from docker hub.
FROM heroiclabs/nakama-pluginbuilder:3.16.0 AS builder

# ENV - Sets environment variables inside the image.
ENV GO111MODULE on
ENV CGO_ENABLED 1

# WORKDIR - Defines the working directory for subsequent 
# instructions in the Dockerfile.
WORKDIR /backend

# COPY - It is used to copy your local files/directories 
# to Docker Container.
COPY . .

# RUN - Executes command in a new image layer.
RUN go build --trimpath --mod=vendor --buildmode=plugin -o ./backend.so

FROM heroiclabs/nakama:3.16.0

COPY --from=builder /backend/backend.so /nakama/data/modules
COPY --from=builder /backend/local.yml /nakama/data/