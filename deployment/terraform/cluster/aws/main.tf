locals {
  container_log_path = "/var/lib/docker/containers"
}
module "haystack-k8s" {
  source = "../../modules/k8s-cluster/aws"
  k8s_aws_nodes_subnet_ids = "${var.aws_nodes_subnet}"
  k8s_aws_ssh_key = "${var.aws_ssh_key}"
  k8s_hosted_zone_id = "${var.aws_hosted_zone_id}"
  k8s_base_domain_name = "${replace(data.aws_route53_zone.haystack_dns_zone.name, "/[.]$/", "")}"
  k8s_master_instance_type = "${var.k8s_node_instance_type}"
  k8s_aws_vpc_id = "${var.aws_vpc_id}"
  k8s_aws_zone = "${var.aws_zone}"
  k8s_aws_utility_subnet_ids = "${var.aws_utilities_subnet}"
  k8s_node_instance_type = "${var.k8s_node_instance_type}"
  k8s_s3_bucket_name = "${var.s3_bucket_name}"
  k8s_aws_region = "${var.aws_region}"
  k8s_node_instance_count = "${var.k8s_node_instance_count}"
  reverse_proxy_port = "${var.reverse_proxy_port}"
}


module "k8s-addons" {
  source = "../../modules/k8s-addons"
  k8s_cluster_name = "${module.haystack-k8s.cluster_name}"
  kubectl_executable_name = "${var.kubectl_executable_name}"
  traefik_node_port = "${var.traefik_node_port}"
  k8s_app_namespace = "${var.k8s_app_name_space}"
  haystack_domain_name = "${module.haystack-k8s.cluster_name}"
  add_monitoring_addons = true
  add_logging_addons = true
  container_log_path = "${local.container_log_path}"
  logging_es_nodes = "2"
  k8s_storage_class = "default"
  grafana_storage_volume = "2Gi"
  influxdb_storage_volume = "2Gi"
  es_storage_volume = "100Gi"
}

module "haystack-infrastructure" {
  source = "../../modules/haystack-infrastructure/kubernetes"
  k8s_app_name_space = "${module.k8s-addons.k8s_app_namespace}"
}

module "haystack-apps" {
  source = "../../modules/haystack-apps/kubernetes"
  kafka_port = "${module.haystack-infrastructure.kafka_port}"
  elasticsearch_port = "${module.haystack-infrastructure.elasticsearch_port}"
  k8s_cluster_name = "${module.haystack-k8s.cluster_name}"
  cassandra_hostname = "${module.haystack-infrastructure.cassandra_hostname}"
  kafka_hostname = "${module.haystack-infrastructure.kafka_hostname}"
  cassandra_port = "${module.haystack-infrastructure.kafka_port}"
  metrictank_hostname = "${module.haystack-infrastructure.metrictank_hostname}"
  metrictank_port = "${module.haystack-infrastructure.metrictank_port}"
  elasticsearch_hostname = "${module.haystack-infrastructure.kafka_port}"
  graphite_hostname = "${module.haystack-infrastructure.kafka_port}"
  k8s_app_namespace = "${module.k8s-addons.k8s_app_namespace}"
}
