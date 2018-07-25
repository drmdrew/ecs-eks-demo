resource "kubernetes_service" "service" {
  metadata {
    name = "${var.container_name}"
  }
  spec {
    selector {
      app = "${kubernetes_pod.pod.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = "${var.container_port}"
      target_port = "${var.container_port}"
    }

    type = "LoadBalancer"
  }
}

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
    }
  }
}