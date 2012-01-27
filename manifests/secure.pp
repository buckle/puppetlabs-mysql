class mysql::secure {
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
  # These don't work, and I can't figure out why.  We need to comment these
  # out until https://github.com/ccaum/puppetlabs-mysql/pull/3#issuecomment-3692714
  # is addressed.
#  database_grant { '@%/test':
#    ensure => absent,
#  }
#  database_grant { '@%/test\_%':
#    ensure => absent,
#  }
}
