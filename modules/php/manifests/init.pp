class php {
  package { 'php':
    ensure => 'installed',
  }

  package { 'php-mbstring':
    ensure => 'installed',
    require => Package['php'],
  }

  package { 'php-process':
    ensure => 'installed',
    require => Package['php'],
  }

  file { '/etc/php.ini':
    source => 'puppet:///modules/php/php.ini',
    owner => 'root',
    group => 'root',
    mode => '644',
    notify => Service['httpd'],
    require => Package['php'],
  }


}
