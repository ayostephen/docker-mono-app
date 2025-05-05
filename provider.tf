provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "vault" {
  token   = ""
  address = "https://vault.sternwatch.com/"
}
