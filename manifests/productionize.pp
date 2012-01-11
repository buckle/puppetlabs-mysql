class mysql::productionize {
  # Removes anonymous users and test DB's from a mysql instance.
  # This manifest is a puppetization of the mysql_secure_installation
  # shell script
  database { 'test':
    ensure => absent,
  }
  database_user { '@localhost':
    ensure => absent,
  }
  database_user { "@${fqdn}":
    ensure => absent,
  }
  database_grant { '@%/test':
    ensure => absent,
  }
  database_grant { '@%/test\_%':
    ensure => absent,
  }
}
