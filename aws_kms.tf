resource "aws_kms_key" "my_sample_rds_storage_kms_bytf" {
  description             = "key to encrypt rds storage."

  # CMKの使用方法を設定する。データの暗号化/復号化(ENCRYPT_DECRYPT)、メッセージの署名および署名の検証(SIGN_VERIFY)が設定できる。
  #  - データの暗号化を行うため、「ENCRYPT_DECRYPT」を設定する。
  key_usage               = "ENCRYPT_DECRYPT"

  # リソースが削除されてからキーを完全に削除するまでの期間(日)。7〜30を指定することができる。
  deletion_window_in_days = 7

}