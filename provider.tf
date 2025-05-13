provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.rPbCSeewC6l8aLx5G4i3QSvo"
  address = "https://vault.sternwatch.com/"
}
