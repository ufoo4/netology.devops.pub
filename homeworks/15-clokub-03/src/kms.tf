resource "yandex_kms_symmetric_key" "my-key" {
  name              = "symetric-key"
  description       = "my first symetric key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}
