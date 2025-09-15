
provider "aws" {
  region = var.region
}

provider "aws" {
  alias      = "plain_text_access_keys_provider"
  region     = "us-west-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

terraform {
  backend "s3" {
    bucket         = "fauzan-terragoat-tfstate"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "ap-southeast-1"
  }
}
