provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.jX7ATWkIZEqDBq82gXmYwIQZ"
  address = "https://vault.sternwatch.com/"
}
