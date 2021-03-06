class mysql::config(
  $root_password = 'UNSET',
  $old_root_password = '',
  $bind_address = '127.0.0.1',
  $port = 3306,
  # rather or not to store the rootpw in /etc/my.cnf
  $etc_root_password = false
) {
  include mysql::params

  # manage root password if it is set
  if !($root_password == 'UNSET') {
    case $old_root_password {
      '': {$old_pw=''}
      default: {$old_pw="-p${old_root_password}"}
    }

    # A script is needed to set the mysql password so it isn't leaked
    # to the process table.  This is put in /var/lib/mysql to support
    # deleting the script when purging mysql from a system
    file { '/var/lib/mysql/mysql_set_pass':
      content => template('mysql/mysql_set_pass.erb'),
      notify  => Exec['set_mysql_rootpw'],
      mode    => 0700,
    }

    exec{ 'set_mysql_rootpw':
      command     => "/var/lib/mysql/mysql_set_pass",
      before      => File['/root/.my.cnf'],
      require     => [Package['ruby-mysql','mysql-server'], Service['mysqld']],
      refreshonly => true,
      notify      => Exec['mysqld-restart'],
    }
    file{'/root/.my.cnf':
      content => template('mysql/my.cnf.pass.erb'),
    }
    if $etc_root_password {
       file{'/etc/my.cnf':
          content => template('mysql/my.cnf.pass.erb'),
          require => Exec['set_mysql_rootpw'],
       }
    }
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '0400',
    notify  => Exec['mysqld-restart'],
    require => Package['mysql-server']
  }
  file { '/etc/mysql':
    ensure => directory,
    mode => '755',
  }
  file { '/etc/mysql/conf.d':
    ensure  => directory,
    mode    => '755',
  }

  file { $mysql::params::config_file:
    content => template('mysql/my.cnf.erb'),
    mode    => '0644',
  }

  file { "/var/log/mysql":
    ensure  => directory,
    mode    => 2755,
    group   => 'dbas',
  }
}
