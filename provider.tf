provider "aws" {
  region = var.region
  profile = var.profile
}

provider "vault" {
  token = "s.Zu9PdjoGpxq4kLW7dAuFC5y0"
  address = "https://vault.hullerdata.com/"
}