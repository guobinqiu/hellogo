FROM golang:1.20 as build
WORKDIR /app
COPY go.mod go.sum ./
ENV GOPROXY=https://goproxy.cn
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

FROM alpine:3.12
WORKDIR /app
COPY --from=build /app/main /app/main
EXPOSE 8000
CMD ["/app/main"]