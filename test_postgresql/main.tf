terraform {
  required_version = ">= 0.11.11"

  #backend "local" {}
}

provider "postgresql" {
  host            = "${local.docker_pg_host}"
  port            = "${local.docker_pg_port}"
  database        = "${local.docker_pg_database}"
  username        = "${local.docker_pg_username}"
  password        = "${local.docker_pg_password}"
  sslmode         = "${local.docker_pg_ssl_mode}"
  connect_timeout = "${local.docker_pg_connect_timeout}"
  #alias           = "dockerdb"
}

locals {
  docker_pg_host            = "0.0.0.0"
  docker_pg_port            = "5432"
  docker_pg_database        = "postgres"
  docker_pg_username        = "admin"
  docker_pg_password        = "admin123456"
  docker_pg_ssl_mode        = "disable"
  docker_pg_connect_timeout = "15"
}

locals {
  apps       = ["gis", "kld", "med", "sbh", "tbb"]
  app_roles  = ["admin", "ro", "rw"]
  role_count = "${length(local.apps) * length(local.app_roles)}"
}

resource "null_resource" "let" {
  count = "${length(local.apps)}"

  triggers {
    db_admins   = "${format("%s_%s", element(local.apps, count.index), element(local.app_roles, 0) )}"
    db_readers  = "${format("%s_%s", element(local.apps, count.index), element(local.app_roles, 1) )}"
    db_writters = "${format("%s_%s", element(local.apps, count.index), element(local.app_roles, 2) )}"
  }
}

resource "random_id" "pg_password" {
  count       = "${local.role_count}"
  byte_length = 10
}

###

locals {
  db_name   = "my_db"
  db_schema = "my_schema"
}

resource "postgresql_schema" "my_schema1" {
  name = "${local.db_schema}"
}

resource "postgresql_role" "role_with_create_database" {
  name = "role_with_create_database"
  create_database = true
}

resource "postgresql_database" "db1" {
  name              = "${local.db_name}"
  owner             = "${postgresql_role.role_with_create_database.name}"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}


resource "postgresql_role" "role" {
  count                     = "${local.role_count}"
  name                      = "${element(concat(null_resource.let.*.triggers.db_admins, null_resource.let.*.triggers.db_readers, null_resource.let.*.triggers.db_writters), count.index)}"
  superuser                 = false
  create_database           = false
  create_role               = false
  inherit                   = false
  login                     = true
  replication               = false
  bypass_row_level_security = false
  connection_limit          = -1
  encrypted_password        = true
  password                  = "${element(random_id.pg_password.*.b64, count.index)}"
  skip_drop_role            = false
  skip_reassign_owned       = false
  valid_until               = "infinity"
}

resource "postgresql_grant" "ro" {
  count       = "${length(null_resource.let.*.triggers.db_readers)}"
  database    = "${local.docker_pg_database}"
  role        = "${element(null_resource.let.*.triggers.db_readers, count.index)}"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]

  depends_on = ["postgresql_role.role"]
}

output "db_logins" {
  value = "${zipmap(
    postgresql_role.role.*.id,
    formatlist("PGPORT=%s PGHOST=%s PGDATABASE=%s PGUSER=%s PGPASSWORD=%s psql", local.docker_pg_port, local.docker_pg_host, local.docker_pg_database, postgresql_role.role.*.id, postgresql_role.role.*.password)
  )}"
}
