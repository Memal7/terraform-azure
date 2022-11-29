# Deploy and manage your Azure infrastructures with Terraform
This repo demonstrate the usage of IaC with Terraform in Azure with some demos.
---
## What's IaC?
IaC is the process of provisioning and managing infrastructure resources through writing and executing code, rather than using manual configuration or GUIs.

## Why do I have to use IaC?
IaC offers many benefits. Just some of them are:
- Provisioning the infrastructure resources in a automation way, which's much faster and consistent than manual.
- Manage multiple environements (Dev, Test, Prod, etc.)
- Repeatable usage of the IaC.
- Versioning of IaC codes with version control (e.g. Git) and you can access always the old versions or update them.
- IaC code can be used as a doc and anyone can access and understand it at any time.

... and much more

---
## What's Terraform?
Terraform is an open source IaC tool maintained by [HashiCorp](https://www.terraform.io/) for deploying cloud infrastructures and managing whole cloud-native application lifecyles through writing and executing codes in a declarative way, rather than manually.
Terraform allows you to write human-readable configuration codes with _Hashicorp Configuration Lanaguage (HCL)_ to define your cloud infrastructures. This code can be used to deploy repeatable and consistent environments across public, private, hybrid, and community cloud providers.

---

## Terraform core components
- **Executable:** A single binary file which contains all core functionality of Terraform. This is the file, that you download.
- **Configuration files:** Contains all configurations or defined infrastructure resources. There can be 1 or more such files (with .tf extension) in a Terraform directory.
- **Provider plugins:** Interacts with many provider services (e.g. Azure) via thier APIs.
- **State data**: Contains informations about the current state of the deployed infrastructure resources (with .tfstate extension).

---

## Terraform workflow
- **configuration files:** Define your resources 
- **terraform init:** Initialize configuration files inside current directory and download the provider plugin from Terraform Registry 
- **terraform plan:** Create an execution plan
- **terraform apply:** Apply the planned execution
- **terrafrom.tfstate:** Terraform will store the current state of deployed resources

![Image 01: Terraform principle](./00_images/terraform-workflow.png)

---

## How to get-started?
### **Install Terraform on macOS**
Install using package manager using following commands
```
brew tap hashicorp/tap
```
```
brew install hashicorp/tap/terraform
```
Or install the binary file from the [Terraform website](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform).

### **Install Terraform on Windows**
Download Terraform from the [Terraform website](https://www.terraform.io/downloads.html) and unzip it. The ZIP will extract a single binary file  _terraform_. Move this file somewhere on your disk where you want Terraform to be installed (e.g. _C:/_ ). Then add the path of this file on your *System environment*.

### **Install Terraform on Linux**
Download Terraform from the [Terraform home page](https://www.terraform.io/downloads.html) and unzip it. Open the Terminal in the folder which Terraform is downloaded, then move the extracted binary file _terraform_ file to the _/etc/local/bin/_ using following command:

```
sudo mv terraform /usr/local/bin/
```

Check your installation using following commmand (the same in all OS):
```
terraform --version
```

### Install Azure CLI
[Download and install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli) and than prove your installation:
```
az version
```

Log in to your Azure account:
```
az login
```

List the available subscriptions in your directory:
```
az account list -o table
```

Choose the right subscription:
```
az account set --subscription "<your-subscription-id>"
```

---

## Reference
[Terraform Developer Docs](https://developer.hashicorp.com/terraform)




