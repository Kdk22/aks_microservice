variables "prefix" {
type = string
description = "Naming prefix for resources"
default = "launch"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}