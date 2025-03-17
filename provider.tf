provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "vault" {
  token   = "s.6KCI59JlvCnRQCFcsdfo6IBF"
  address = "https://vault.hullerdata.com/"
}