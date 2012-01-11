class mysql::productionize {
  database { "test":
    ensure => absent,
  }
}
