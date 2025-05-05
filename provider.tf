provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "vault" {
  token   = "s.yLOteGvtElyRWQQeR40DNm77"
  address = "https://vault.sternwatch.com/"
}
