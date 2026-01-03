# ─────────────── Build Stage ───────────────
FROM --platform=$BUILDPLATFORM golang:1.21-alpine AS builder

WORKDIR /src

# 安装编译需要的工具
# git 用来 checkout 代码
# bash 用来运行官方 build 脚本
RUN apk add --no-cache git bash

# 把全部源码复制进来
COPY . .

# 官方源码里有 crossbuild.bash，用它编译静态二进制
# 设置 TARGETOS 和 TARGETARCH 由 buildx 提供
ARG TARGETOS TARGETARCH

# make sure script executable
RUN chmod +x ./crossbuild.bash

# 运行官方提供的构建脚本
# 这个脚本内部执行了针对不同架构的构建步骤
RUN ./crossbuild.bash

# ─────────────── Final Stage ───────────────
FROM alpine:latest

# 把 build 阶段输出的二进制复制过来
COPY --from=builder /src/gocryptfs /usr/local/bin/gocryptfs

# 默认执行 gocryptfs
ENTRYPOINT ["gocryptfs"]
