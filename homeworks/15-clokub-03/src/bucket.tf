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

resource "yandex_storage_bucket" "gny-201222" {
  access_key = "${yandex_iam_service_account_static_access_key.s3-robot-static-key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.s3-robot-static-key.secret_key}"
  bucket     = "gny-201222"
  acl        = "public-read"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.my-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "avatar-picture" {
  access_key = "${yandex_iam_service_account_static_access_key.s3-robot-static-key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.s3-robot-static-key.secret_key}"
  bucket = "gny-201222"
  key    = "avatar"
  source = "../img/avatar.jpg"

  depends_on = [
  yandex_storage_bucket.gny-201222
  ]
}
