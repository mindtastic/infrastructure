variable "cluster_networks" {
  type = list(string)
  description = "Pod and Service Network CIDRs"
  default = []
}