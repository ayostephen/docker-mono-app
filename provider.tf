provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "vault" {
  token   = "s.D9M5pWOnzhJyk4fWdXNBNOkl"
  address = "https://vault.hullerdata.com/"
}