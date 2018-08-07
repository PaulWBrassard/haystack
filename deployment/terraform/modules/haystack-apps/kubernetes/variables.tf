variable "elasticsearch_hostname" {}
variable "elasticsearch_port" {}
variable "kafka_hostname" {}
variable "kafka_port" {}
variable "cassandra_hostname" {}
variable "cassandra_port" {}
variable "graphite_hostname" {}
variable "graphite_port" {}
variable "graphite_enabled" {}
variable "haystack_cluster_name" {}
variable "kubectl_context_name" {}
variable "kubectl_executable_name" {}
variable "k8s_app_namespace" {}
variable "app-node_selector_label"{}


# ========================================
# Haystack
# ========================================

variable "traces" {
  type = "map"
}

variable "trends" {
  type = "map"
}

variable "pipes" {
  type = "map"
}

variable "collector" {
  type = "map"
}

variable "service-graph" {
  type = "map"
}

variable "ui" {
  type = "map"
}

variable "metrictank" {
  type = "map"
}


# ========================================
# Adaptive Alerting
# ========================================

variable "alerting" {
  type = "map"
}

variable "anomaly-validator" {
  type = "map"
}

variable "ad-mapper" {
  type = "map"
}

variable "ad-manager" {
  type = "map"
}

variable "modelservice" {
  type = "map"
}

variable "aquila-trainer" {
  type = "map"
}

variable "aquila-detector" {
  type = "map"
}
