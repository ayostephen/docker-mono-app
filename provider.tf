provider "aws" {
  region  = var.region
  # profile = var.profile
}

provider "vault" {
  token   = "s.BdT4JV7cBr2a3B5JylfZzpuH"
  address = "https://vault.sternwatch.com/"
}
