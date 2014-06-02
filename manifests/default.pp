File { owner => 0, group => 0, mode => 0644 }
Exec { logoutput => true, path => [ "/usr/bin", "/bin", "/sbin", "/usr/sbin"  ] }
Package { platform => 'x86_64' }

group { "puppet":
	ensure => "present",
}

file { '/etc/motd':
	content => "Welcome to your Vagrant-built virtual machine! Managed by Puppet.\n"
}


file { '/etc/sysconfig/selinux':
  content => "SELINUX=disabled\nSELINUXTYPE=targeted",
}

package { 'vim-enhanced.x86_64':
  ensure => installed,
}

package { 'wget':
  ensure => installed,
}

package { 'bash':
  ensure => installed,
}

exec { 'yum_update':
  command => 'yum -y update',
  path => '/usr/bin/',
}

exec { 'yum_core':
  command => 'yum -y groupinstall core',
  path => '/usr/bin/',
  require => Exec['yum_update']
}

exec { 'yum_base':
  command => 'yum -y groupinstall base',
  path => '/usr/bin/',
  require => Exec['yum_core'],
  before => [ Package['gcc'], Package['asterisk'], Class['apache'], Class['php'], Class['::mysql::server'], Class['asterisk'] ],
}

service { 'iptables':
  ensure => stopped,
  enable => false,
  hasstatus => true,
  hasrestart => true,
}

## Install mysql

include '::mysql::client'

class {'mysql::server':
  root_password    => 'default',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  service_enabled   => 'true',
}

class {'mysql::bindings':
  php_enable => 1,
}


$ASTERISK_DB_PW='asterisk'

mysql::db { 'asterisk':
  user => 'asterisk',
  password => $ASTERISK_DB_PW,
  host => 'localhost',
  grant => 'ALL', 
  sql => '/usr/src/freepbx/SQL/newinstall.sql',
  require => Exec['git_repo_freepbx'],
}

mysql::db { 'asteriskcdrdb':
  user => 'asterisk',
  password => $ASTERISK_DB_PW,
  host => 'localhost',
  grant => 'ALL', 
  sql => '/usr/src/freepbx/SQL/cdr_mysql_table.sql',
  require => Exec['git_repo_freepbx'],
}

## Install apache

class { 'apache': 
  manage_user => false,
  manage_group => false,
  user => 'asterisk',
  group => 'asterisk',
  require => [ Group['asterisk'], User['asterisk'] ], 
}

## Install php

include php

php::module { "mysql": }
php::module { "mbstring": }
php::module { "process": }
php::pear::module { "DB": }

include apache::mod::php

#php::conf { 'upload_max_filesize=20M': }

file { '/var/www/':
  ensure => directory,
  owner => 'asterisk',
  group => 'asterisk',
  recurse => true,
  require => [ User['asterisk'] ],
}

file { '/var/www/html':
  ensure => directory,
  owner => 'asterisk',
  group => 'asterisk',
  recurse => true,
  require => [ User['asterisk'], File['/var/www'] ],
}

# Set up asterisk
include asterisk

Class['asterisk'] -> Class['freepbx::dependencies']


# Set up freepbx
$VER_FREEPBX=2.11

include git
include freepbx::dependencies

git::repo { 'freepbx':
  path => '/usr/src/freepbx',
  source => 'http://git.freepbx.org/scm/freepbx/framework.git',
  git_tag => "release/$VER_FREEPBX",
}

file { '/usr/src/freepbx/start_asterisk':
  ensure => present,
  mode => 0744,
}

file { '/usr/src/freepbx/install_amp':
  ensure => present,
  mode => 0744,
}

exec {'asterisk_start':
  command => '/usr/src/freepbx/start_asterisk start',
  cwd => '/usr/src/freepbx',
  require => [ Package['bash'],
               Package['asterisk'],   
               Package['asterisk-configs'],  
               Package['asterisk-sounds-core-en'],  
               Class['mysql::server'], 
               Class['php'], 
               Class['apache'], 
               Class['asterisk'],
               Exec['git_repo_freepbx'], 
               Mysql_database['asterisk'], 
               Mysql_database['asteriskcdrdb'], 
               File['/usr/src/freepbx/start_asterisk'] ]
}

exec {'install_amp':
  command => "/usr/src/freepbx/install_amp --username=asterisk --password=$ASTERISK_DB_PW --force-overwrite=yes",
  cwd => '/usr/src/freepbx',
  require => [ Exec['asterisk_start'] , File['/usr/src/freepbx/install_amp'] ]
}

file {'/var/log/asterisk/freepbx.log':
  owner => 'asterisk',
  require => [ User['asterisk'], Exec['install_amp'] ],
} 

exec { 'mohmp3':
  command => 'ln -s /var/lib/asterisk/moh /var/lib/asterisk/mohmp3',
  require => Exec['install_amp']
}

exec { 'amportal':
  command => "amportal start",
  cwd => '/usr/src/freepbx',
  require => [ Exec['mohmp3'] ]
}


