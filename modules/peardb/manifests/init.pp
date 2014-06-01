class peardb {
  package { 'php-pear':
    ensure => 'installed',
    require => Class['php'],
  }

  exec { 'pear_install_db':
    command => 'pear install db',
    path => '/usr/bin',
    require => Package['php-pear'],
  }

}
