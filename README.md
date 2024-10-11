基于caddy反代，打包为docker镜像，简单方便一键启动

# 优点

- 简单方便一键启动
- Docker + Github
- 不用编辑配置文件
- 只需要添加DNS解析
- 自动申请续期ssl证书，

# 参数
|选项|解释|
|---|---|
|DOMAIN|上级域名|
|PORT|端口，默认443|
|HTTPS|是否自动申请ssl证书，disable_redirects为开启自动申请(默认)，off为关闭自动申请|

---

### 演示域名为：`666.xyz`


# 不套cloudflare（占用443端口）
由caddy自动申请管理证书，需要在cf解析泛域名：`*.hub.666.xyz` 
解析后直接docker启动，caddy会自动申请ssl证书，注意不要占用443端口

```
docker run -d \
  --name mirror-proxy \
  --net host \
  --restart=always \
  -v /caddy:/data \
  -e DOMAIN=hub.666.xyz \
  javaow/mirror-proxy
```
![image](https://img001.prntscr.com/file/img001/pq5km4LERNy6q0-40nll_A.png)

# 套cloudflare（占用80端口）
套用cloudflare的cdn证书，需要修改PORT端口为80，并且设置HTTPS参数为off，关闭caddy自动申请证书
#### 注意：cloudflare的证书要求不能是三级域名，只能是二级域名，所以需要手动去cf添加解析，并打开云朵，SSL设置为`灵活`

```
// 需要添加如下二级域名解析，不能是三级域名，cf三级域名没有ssl证书
docker.666.xyz
github.666.xyz
github-file.666.xyz
gcr.666.xyz
ghcr.666.xyz
quay.666.xyz
k8s-io.666.xyz
k8s-pkg-dev.666.xyz
```
依次添加上面8个二级域名，注意`开启云朵` ，如果用不到那么多反代可以不解析，只解析docker 和github即可
ipv6也可以，反正套了cf
![image](https://img001.prntscr.com/file/img001/1iP9Bco8RQKnmroMBfbIKA.png)

启动即可
```
docker run -d \
  --name mirror-proxy \
  --net host \
  --restart=always \
  -v /caddy:/data \
  -e DOMAIN=666.xyz \
  -e PORT=80 \
  -e HTTPS=off \
  javaow/mirror-proxy
```



# === Github反代使用 ===
演示为不套cf，域名为三级域名，如果套cf改为二级域名

git克隆拉取
```
// 原命令
git clone https://github.com/wy2919/mirror-proxy.git

// 替换后（替换域名为反代域名）
git clone https://github.hub.666.xyz/wy2919/mirror-proxy.git
```

仓库文件直链
```
// 原url
https://raw.githubusercontent.com/wy2919/mirror-proxy/master/Caddyfile

// 替换后（替换域名为反代域名）
https://github.hub.666.xyz/wy2919/mirror-proxy/master/Caddyfile
```

Releases文件直链
```
// 原url
https://github.com/SagerNet/sing-box/releases/download/v1.9.7/sing-box-1.9.7-linux-amd64.tar.gz

// 替换后（替换域名为反代域名）
https://github-file.hub.666.xyz/SagerNet/sing-box/releases/download/v1.9.7/sing-box-1.9.7-linux-amd64.tar.gz
```

# === Docker反代使用 ===

#### DockerHub(默认仓库)

官方镜像(需要加library)
```
// 原命令
docker pull alpine:latest

// 替换后
docker pull docker.hub.666.xyz/library/alpine:latest
```
个人镜像(前面加上反代域名)

```
// 原命令
docker pull javaow/tailscale-derp:latest

// 替换后
docker pull docker.hub.666.xyz/javaow/tailscale-derp:latest
```

#### gcr(替换域名为反代域名)

```
// 原命令
docker pull gcr.io/kaniko-project/executor:debug

// 替换后
docker pull gcr.hub.666.xyz/kaniko-project/executor:debug
```

#### ghcr(替换域名为反代域名)

```
// 原命令
docker pull ghcr.io/openfaas/queue-worker

// 替换后
docker pull ghcr.hub.666.xyz/openfaas/queue-worker
```

#### quay(替换域名为反代域名)

```
// 原命令
docker pull quay.io/libpod/alpine

// 替换后
docker pull quay.hub.666.xyz/libpod/alpine
```

#### k8s.gcr.io(替换域名为反代域名)

```
// 原命令
docker pull k8s.gcr.io/kube-apiserver:v1.30.0
 
// 替换后
docker pull k8s-io.hub.666.xyz/kube-apiserver:v1.30.0
```







