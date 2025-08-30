FROM golang:1.23.5-alpine AS builder


COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o /app/k8s ./main.go

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/k8s .

ENTRYPOINT ["./k8s"]

EXPOSE 8080