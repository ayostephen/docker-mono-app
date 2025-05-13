provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.xLONlih2O3pf18K12q4gKxxQ"
  address = "https://vault.sternwatch.com/"
}
