resource "yandex_mdb_mysql_user" "mysqluser" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = "mysqluser"
  password   = "mysqlpassword"
  permission {
    database_name = "netology_db"
    roles         = ["ALL"]
  }

  depends_on = [
    yandex_mdb_mysql_database.netology_db
  ]
}
