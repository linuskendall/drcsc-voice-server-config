class asterisk {
  package  {'asterisk':
    ensure => 'installed',
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-configs': 
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-core-en':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-core-en-gsm':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-core-en-ulaw':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-extra-en':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-extra-en-gsm':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }

  package {'asterisk-sounds-extra-en-ulaw':
    ensure => installed,
    require => Package['asterisk'],
    install_options => ['--enablerepo=asterisk-11'],
  }


  group { 'asterisk':
    ensure => present,
  }

  user { 'asterisk':
    ensure => present,
    gid => 'asterisk',
    require => Group['asterisk'],
  }

  file { '/var/lib/asterisk/sounds/digits':
    ensure => 'link',
    target => '/usr/share/asterisk/sounds/digits/',
    require => [ Package['asterisk-sounds-extra-en'], Package['asterisk-sounds-core-en'] ],
  }

  file { '/var/run/asterisk':
    ensure => present,
    owner => 'asterisk',
    group => 'asterisk',
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }

  file { '/etc/asterisk':
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    recurse => true,
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }

  file { '/var/lib/asterisk':
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    recurse => true,
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }


  file { '/var/log/asterisk':
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    recurse => true,
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }

  file { '/var/spool/asterisk':
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    recurse => true,
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }

  file { '/usr/lib/asterisk':
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    recurse => true,
    require => [ Package['asterisk'], User['asterisk'] ],
    before => [ Exec['asterisk_start'] ]
  }

  file {"/var/lib/asterisk/agi-bin/":
    ensure => present,
    source => "puppet:///modules/asterisk/googletts.agi",
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => Service['asterisk'],
  }

  file{"/etc/asterisk/manager_custom.conf":
    ensure => present,
    source => 'puppet:///modules/asterisk/manager_custom.conf',
    owner => 'asterisk',
    group => 'asterisk',
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => Service['asterisk']
  }

  file{"/etc/asterisk/extensions_custom.conf":
    ensure => present,
    source => 'puppet:///modules/asterisk/extensions_custom.conf',
    owner => 'asterisk',
    group => 'asterisk',
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => Service['asterisk']
  }

  service { 'asterisk':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true
  }
}
