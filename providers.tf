terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws"{
    shared_config_files = ["C:\\Users\\wolnicki\\Documents\\.aws\\config"]
    shared_credentials_files = ["C:\\Users\\wolnicki\\Documents\\.aws\\credentials"]

}