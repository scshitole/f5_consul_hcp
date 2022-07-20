## Global Config
log_level   = "DEBUG"
working_dir = "sync-tasks"
port        = 8558

syslog {}

buffer_period {
  enabled = true
  min     = "5s"
  max     = "20s"
}

# Consul Block
consul {
  address = "https://scs-consul-cluster.consul.xxxxxxxxxxxe.aws.hashicorp.cloud"
  token = "xxxxxxxxxxxdc-9d57-1bdc87a2f635"
}

# Driver block
driver "terraform-cloud" {
  hostname     = "https://app.terraform.io"
  organization = "SCStest"
  token        = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx9syeruPfg"
  // Optionally set the token to be securely queried from Vault instead of
  // written directly to the configuration file.
  // token = "{{ with secret \"secret/my/path\" }}{{ .Data.data.foo }}{{ end }}"
required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }

}

terraform_provider "bigip" {
  address  = "1.2.3.4:8443"
  username = "admin"
  password = "LkUD8eDXlF"
}

task {
  name = "AS3"
  description = "BIG-IP example"
  source = "f5devcentral/consul-sync-event/bigip"
  providers = ["bigip"]
  services = ["nginx"]
  variable_files = ["terraform.tfvars"]
}

