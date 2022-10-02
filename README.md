# terraform-exercises


### Install and basical usage

[terraform download](https://www.terraform.io/downloads)

```
# mac 
$ brew tap hashicorp/tap 
$ brew install hashicorp/tap/terraform


# Or Linux With CentOS/RHEL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# Or Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform


# check version
❯ terraform -version
Terraform v1.2.9
on darwin_amd64

# aotocomplete 
❯ terraform -install-autocomplete


```

**New job**

```
✦ ❯ mkdir docker

terraform on  main [!?]
✦ ❯ cd docker

# 编写好 tf 文件后，检查语法

✦ ❯ terraform validate
Success! The configuration is valid.

```

[Nginx App with terraform](./docker/Nginx.tf)


**init project**

`注意`：当曾经设置或者修改过 provider 相关配置后，需要重新初始化一次来更新元配置

```
# init the terraform project
# 初始化过程中会去 安装相关的 provider plugins，同时也会去验证签名
# 之后会创建 .terraform.lock.hcl 锁文件来记录 provider 相关信息
# 接下来就可以真正使用了 terraform 进行工作了

✦ ❯ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 2.13.0"...
- Installing kreuzwerker/docker v2.13.0...
- Installed kreuzwerker/docker v2.13.0 (self-signed, key ID 24E54F214569A8A5)
...
...
```
init 之后，可以使用 `terraform plan` 来查看本次变更内容，以及具体需要执行的步骤

**plan project**

```
# 执行 terraform plan 来查看整体任务执行的编排计划
# 可以展示出来我们创建一个docker 容器后，都使用了哪些资源，以及哪些参数
❯ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx will be created
  + resource "docker_container" "nginx" {
      + attach           = false
      + bridge           = (known after apply)
      + command          = (known after apply)
      + container_logs   = (known after apply)
      + entrypoint       = (known after apply)
      + env              = (known after apply)
      + exit_code        = (known after apply)
      + gateway          = (known after apply)
      + hostname         = (known after apply)
      + id               = (known after apply)
      + image            = (known after apply)
      + init             = (known after apply)
      + ip_address       = (known after apply)
      + ip_prefix_length = (known after apply)
      + ipc_mode         = (known after apply)
      + log_driver       = "json-file"
      + logs             = false
      + must_run         = true
      + name             = "tutorial"
      + network_data     = (known after apply)
      + read_only        = false
      + remove_volumes   = true
      + restart          = "no"
      + rm               = false
      + security_opts    = (known after apply)
      + shm_size         = (known after apply)
      + start            = true
      + stdin_open       = false
      + tty              = false

      + healthcheck {
          + interval     = (known after apply)
          + retries      = (known after apply)
          + start_period = (known after apply)
          + test         = (known after apply)
          + timeout      = (known after apply)
        }

      + labels {
          + label = (known after apply)
          + value = (known after apply)
        }

      + ports {
          + external = 8000
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + keep_locally = false
      + latest       = (known after apply)
      + name         = "nginx:latest"
      + output       = (known after apply)
      + repo_digest  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
╷
│ Warning: Deprecated attribute
│
│   on Nginx.tf line 18, in resource "docker_container" "nginx":
│   18:   image = docker_image.nginx.latest
│
│ The attribute "latest" is deprecated. Refer to the provider documentation for details.
│
│ (and one more similar warning elsewhere)
╵

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

`注意：` 可以看到，对于一些初学者，或者不规范的 terraform 配置而言，执行 `terraform plan` 的时候，会自动提示出来告诉用户进行优化。如此一来，对于企业内部而言，未来的基础架构只会越来越健壮。

因此，我们需要将 docker image 指定成固定的 tag，而不是使用 latest 的标签。

**apply your project**


```
# 当执行 apply 的时候，会有再次确认的过程
❯ terraform apply
...
...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 2s [id=6110b693980b4e80ea7dafcb63d81cda53b1778e908c81230a95cfa8a4388a8f]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

```


**check your project**

当 apply 完成后，即可实际访问验证交付的基础设施。

```
# 查看本地的docker容器，并测试直接访问docker 

❯ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
6110b693980b   nginx:1.23.1   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:8000->80/tcp   CloudNativeOps

terraform/docker on  main [!?] via 💠 default
❯ curl localhost:8000
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

**destroy your project**

`注意：` destroy 命令用于销毁当前基础设施，但是通常情况下基础设施可能存在依赖资源，比如 container 依赖 image，此时就会发现基础设施销毁不干净，这个时候就需要使用到 `terraform apply` 指令里的 `-destroy` 参数了

```
# 查看当前项目中存在哪些状态
# 可以看到当前项目下，存在docker 的 image 和 container 两种资源
❯ terraform state list
docker_container.nginx
docker_image.nginx

# 销毁当前环境
terraform apply -destroy

```

看到这里，有人会说，这不就是以前的 docker compose 吗，实际上还没有 docker-compose 更优雅更好用。

其实的确是的，不论是 `docker-compose` 还是 `ansible-playbooks` 都是属于 基础设施即代码(IaC) 领域里最早实践声明式无差别交付基础设施的一种方式，只是大家都仅局限于某一种特定场景。

然而随着 云原生(CloudNative) 的发展，大部分企业的基础设施和业务都生于云，长于云，但是对于基础设施以及 SRE 人员来说，却没有一个可以用于声明式交付云上基础设施的工具和标准，因此[HashiCorp](https://www.hashicorp.com/) 看到了这块的问题，并以此来设计并开发了 [Terraform](https://www.hashicorp.com/products/terraform)，并且基于 plugins 的方式来拓展生态，这样就使得使用者在一定程度上可以自己根据实际需求来开发或者提供 Provider，从而真正实现云上基础设施的统一交付。

**备注**

当前 terraform 社区已经支持多家云厂商的 provider，并且在基础设置软件领域也支持了很多，比如 Docker、Kubernetes 等，同时 terraform 内部也支持 modules 机制，因此，如果你们的基础设置和业务有依赖云，那 terraform 一定是一个值得研究的工具。

`注意：` terraform modules 机制可以使得从本地文件和远程文件中加载模块，当前 terraform 支持各种远程资源，包括 Terraform Registry，各种版本控制系统，HTTP URLs 以及 Terraform Cloud等。

### terraform 概念和语法

- `required_providers`: 在项目中声明需要依赖的 providers 
- `provider`:  指定 provider
- `resource`: 声明 资源
- `module`: 声明模块，一般用于交付比较复杂的基础设施时，复用其他基础设施
- `variable`: 定义变量，可以用于项目传参或使用 module 时传参

**Modules 最佳实践**

建议每个 terrform 从业者都遵循这些最佳实践来使用模块：
- 命名 provider 为 `terraform-<PROVIDER>-<NAME>` 格式，
- 在编写配置一开始，就考虑使用 modules 机制。需要注意的是，及时是一个人管理的复杂配置，在一开始也应该设计成模块式架构
- 使用本地模块来组织和封装代码。即使一开始你并没有使用或发布远程模块，
- 使用公共的 Terraform Registry 仓库来寻找可用的 modules
- 和你的团队发布和共享模块

[terraform registry](https://registry.terraform.io/)

**使用 terraform 一键交付 腾讯云VPC**

```
$ cd tencent-cloud/vpc 

$ terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of tencentcloudstack/tencentcloud from the dependency lock file
- Using previously-installed tencentcloudstack/tencentcloud v1.78.3
...
...


$ terraform plan
module.vpc.data.tencentcloud_instance_types.default: Reading...
module.vpc.data.tencentcloud_instance_types.default: Still reading... [10s elapsed]
module.vpc.data.tencentcloud_instance_types.default: Read complete after 19s [id=867170707]
...
...


$ terraform apply
module.vpc.data.tencentcloud_instance_types.default: Reading...
module.vpc.data.tencentcloud_instance_types.default: Still reading... [10s elapsed]
module.vpc.data.tencentcloud_instance_types.default: Read complete after 16s [id=867170707]
...
...

Outputs:

route_entry_id = [
  "877637.rtb-qv5c5hrb",
]
route_table_id = [
  "rtb-qv5c5hrb",
]
subnet_id = [
  "subnet-5jv90zw7",
]
vpc_id = "vpc-j6bkuhts"


# terraform output 可以格式化输出任务的输出结果
$ terraform output
route_entry_id = [
  "877637.rtb-qv5c5hrb",
]
route_table_id = [
  "rtb-qv5c5hrb",
]
subnet_id = [
  "subnet-5jv90zw7",
]
vpc_id = "vpc-j6bkuhts"

```

等完全 apply 完成之后，即可以在 云控制台上看到对应的资源已经交付。

![terraform-tencent-vpc](https://tva1.sinaimg.cn/large/006y8mN6gy1h6r136shhrj317908baav.jpg)

看到这里可能有人会要问了，为何默认指定的是 `北京` 的资源呢，这是因为一般对于 云厂商而言，provider 中需要指定 相关的token，例如: 

```
provider "tencentcloud" {
  secret_id  = "************************************" # 云 API 密钥 SecretId
  secret_key = "********************************" # 云 API 密钥 SecretKey
  region     = "ap-chengdu" # 地域，完整可用地域列表参考: https://cloud.tencent.com/document/product/213/6091
}

```

但是一般对于基础设施而言，这种 hard code 的方式就显的不那么安全且不专业了，因此，在上面这个示例中，我们采用了如下环境变量的方式，以此来让 tencentcloud 的 provider 能够自动加载密钥和region 相关信息。

```
    $ export TENCENTCLOUD_SECRET_ID="your_fancy_accessid"
    $ export TENCENTCLOUD_SECRET_KEY="your_fancy_accesskey"
    $ export TENCENTCLOUD_REGION="ap-beijing"
```

**创建CVM**

```
$ cd tencent-cloud/cvm

$ terraform init
$ terraform plan
...
...
$ terraform apply
...
...
$ terraform show --json
...
...

# 当我们再次执行的时候，就会发现自动检测到当前配置已经存在且没有变更
$ ❯ terraform plan
data.tencentcloud_image.ubuntu: Reading...
tencentcloud_security_group.gogoops: Refreshing state... [id=sg-75dkfn3n]
tencentcloud_vpc.CloudNativeOps: Refreshing state... [id=vpc-c12uxxwo]
data.tencentcloud_image.ubuntu: Read complete after 1s [id=2103607329]
tencentcloud_security_group_rule.sg_rule_test: Refreshing state... [id=eyJzZ19pZCI6InNnLTc1ZGtmbjNuIiwicG9saWN5X3R5cGUiOiJpbmdyZXNzIiwiY2lkcl9pcCI6IjAuMC4wLjAvMCIsInByb3RvY29sIjoidGNwIiwicG9ydF9yYW5nZSI6IjIyLDgwIiwiYWN0aW9uIjoiYWNjZXB0Iiwic291cmNlX3NnX2lkIjoiIiwiZGVzY3JpcHRpb24iOiIifQ==]
tencentcloud_route_table.rtb_goops: Refreshing state... [id=rtb-mpnyhghz]
tencentcloud_subnet.subnet_6: Refreshing state... [id=subnet-67qb95dl]
tencentcloud_instance.CloudNativeOps[0]: Refreshing state... [id=ins-q85xkkvd]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.



```

这样一来，我们就完成了一次性创建 VPC，subnet，security group，cvm 等多个资源。

![tencent-vpc-subnet](https://tva1.sinaimg.cn/large/006y8mN6gy1h6r2ydhbobj315g09775i.jpg)

![tencent-cvm](https://tva1.sinaimg.cn/large/006y8mN6gy1h6r2znmsmyj31420c60um.jpg)

