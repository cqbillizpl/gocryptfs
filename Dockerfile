# 构建阶段
FROM golang:1.21-alpine AS builder
WORKDIR /src

# 取所有源码
COPY . .

# 安装依赖工具
RUN apk add --no-cache git

# 编译 ARM64 版本
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o /gocryptfs

# 运行阶段
FROM alpine:3.18
COPY --from=builder /gocryptfs /usr/local/bin/gocryptfs
ENTRYPOINT ["gocryptfs"]
