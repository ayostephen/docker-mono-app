provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.k2ds08Z9cselU1adJvlqrdXk"
  address = "https://vault.sternwatch.com/"
}
