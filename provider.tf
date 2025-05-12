provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.UDwqehInGBrwcHTwmnCSpSuQ"
  address = "https://vault.sternwatch.com/"
}
