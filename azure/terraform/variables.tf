variable "name" {
  type = string
  default = "testing"
}

variable "workers_count" {
  default = "2"
}

variable "vm_size" {
  type = string
  default = "Standard_D2as_v5"
}

variable "location" {
  type = string
  default = "East US"
}