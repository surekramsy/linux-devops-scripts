# Docker Image Pull Steps from ECR

## Login to AWS ECR

```bash
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 123456789012.dkr.ecr.ap-south-1.amazonaws.com
```

## Pull Docker Image

```bash
sudo docker pull 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest
```

## Save Docker Image as TAR File

```bash
sudo docker save -o explorer-backend-dev-latest.tar 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest
```

---

# Sample Output

## ECR Login

```text
ubuntu@ip-10-0-8-169:~$ aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 123456789012.dkr.ecr.ap-south-1.amazonaws.com
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
ubuntu@ip-10-0-8-169:~$
```

## Pull Image

```text
ubuntu@ip-10-0-8-169:~$ sudo docker pull 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest

explorer-backend-dev-latest: Pulling from tokenborg/explorer
25f1d6b1951a: Pull complete
93d28a21e960: Pull complete
456314e86fcf: Pull complete
4f4fb700ef54: Pull complete
3c35040e4358: Pull complete
694c1f94dc22: Pull complete
373d13e2f915: Pull complete

Digest: sha256:6b20f4aecc2d9c6dfd6e479b64e13ba05c615552a86ec6d9ea4157b535cca064

Status: Downloaded newer image for 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest

123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest

ubuntu@ip-10-0-8-169:~$
```

## Verify Docker Images

### Without sudo

```bash
docker images
```

Output:

```text
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied
```

### With sudo

```bash
sudo docker images
```

Output:

```text
REPOSITORY                                                         TAG                           IMAGE ID       CREATED             SIZE
123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer   explorer-backend-dev-latest   b47cf93bdbf3   About an hour ago   398MB
jumpserver/koko                                                    v4.10.8-ce                    018853eb7645   7 months ago        608MB
jumpserver/lion                                                    v4.10.8-ce                    a14b637bf3a2   7 months ago        205MB
jumpserver/chen                                                    v4.10.8-ce                    30161511bfb1   7 months ago        463MB
jumpserver/core                                                    v4.10.8-ce                    e857d790786a   7 months ago        982MB
jumpserver/web                                                     v4.10.8-ce                    64b8dbfb7a73   7 months ago        245MB
busybox                                                            latest                        925ff61909ae   19 months ago       4.42MB
postgres                                                           16.3-bullseye                 019e55863fd0   24 months ago       400MB
redis                                                              7.0-bullseye                  9316221abf0d   2 years ago         117MB
```

## Export Image to TAR

```bash
sudo docker save -o explorer-backend-dev-latest.tar 123456789012.dkr.ecr.ap-south-1.amazonaws.com/tokenborg/explorer:explorer-backend-dev-latest
```

## Verify TAR File

```bash
ls -ltr explorer-backend-dev-latest.tar
```

Output:

```text
-rw------- 1 root root 404728320 May 7 08:36 explorer-backend-dev-latest.tar
```
