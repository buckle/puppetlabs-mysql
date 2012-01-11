class mysql::productionize {
  database { "test":
    ensure => absent,
  }
  database_grant { "''@'%'/test":
    ensure => absent,
  }
  database_grant { "''@'%'/test\_%":
    ensure => absent,
  }
}
