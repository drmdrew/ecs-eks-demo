resource "kubernetes_pod" "pod" {
  metadata {
    name = "${var.container_name}"
    labels {
      app = "${var.container_name}"
    }
  }

  spec {
    container {
      image = "${var.container_image}"
      name  = "${var.container_name}"
      args = "${var.container_command}"
    }
  }
}

// TODO: would really like to play with deployment, etc.
// See https://github.com/terraform-providers/terraform-provider-kubernetes/issues/3

resource "kubernetes_service" "service" {
  metadata {
    name = "${var.container_name}"
  }
  spec {
    selector {
      app = "${kubernetes_pod.pod.metadata.0.labels.app}"
    }
    type = "LoadBalancer"
    session_affinity = "None"
    port {
      port = "${var.container_port}"
      target_port = "${var.container_port}"
    }

  }
}