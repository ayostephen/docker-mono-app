provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.iPPJ6kvtXxvgtsAsYkasrjUq"
  address = "https://vault.hullerdata.com/"
}
