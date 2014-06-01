class httpd {
  package { 'httpd':
    ensure => 'installed',
  }

  file { '/etc/httpd/conf/httpd.conf':
    source => 'puppet:///modules/httpd/httpd.conf',
    owner => 'root',
    group => 'root',
    mode => '644',
    notify => Service['httpd'],
    require => Package['httpd'],
  }

  service { 'httpd':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
