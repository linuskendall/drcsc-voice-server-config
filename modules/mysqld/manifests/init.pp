class mysqld {
  package { 'mysql-server':
    ensure => 'installed',
  }

  file { '/etc/mysqld/server.cnf':
    source => 'puppet:///modules/mysqld/my.cnf',
    owner => 'root',
    group => 'root',
    mode => '640',
    notify => Service['mysqld'],
    require => Package['mysql-server'],
  }

  service { 'mysqld':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
