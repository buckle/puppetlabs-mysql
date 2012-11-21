class mysql::server::monitor (
  $mysql_monitor_username,
  $mysql_monitor_password,
  $mysql_monitor_hostname
) {

  database_user{
    "${mysql_monitor_username}@${mysql_monitor_hostname}":
      ensure        => present,
      password_hash => mysql_password($mysql_monitor_password),
      require       => Service['mysqld'],
  }
  database_grant { "${mysql_monitor_username}@${mysql_monitor_hostname}":
    privileges    => [ 'process_priv', 'super_priv' ],
    require       => [ Mysql_user["${mysql_monitor_username}@${mysql_monitor_hostname}"], Service['mysqld']],
  }
}

