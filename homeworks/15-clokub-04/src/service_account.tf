#================================
#=== Сервисный аккаунт для s3 ===
#================================
resource "yandex_iam_service_account" "s3-robot" {
  folder_id = "${var.yandex_folder_id}"
  name      = "s3-robot"
}

resource "yandex_resourcemanager_folder_iam_member" "s3-robot-editor" {
  folder_id = "${var.yandex_folder_id}"
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.s3-robot.id}"
}

resource "yandex_iam_service_account_static_access_key" "s3-robot-static-key" {
  service_account_id = "${yandex_iam_service_account.s3-robot.id}"
}

#=================================
#=== Сервисный аккаунт для k8s ===
#=================================
resource "yandex_iam_service_account" "k8s-robot" {
  name        = "k8s-robot"
  description = "K8S regional service account"
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s-clusters-agent" {
  folder_id = "${var.yandex_folder_id}"
  role      = "k8s.clusters.agent"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-robot.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
  folder_id = "${var.yandex_folder_id}"
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-robot.id}"
  ]
}
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = "${var.yandex_folder_id}"
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-robot.id}"
  ]
}

resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.my-kms-key.id
  role             = "viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-robot.id}",
  ]
}
