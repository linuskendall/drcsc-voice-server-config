class freepbx::dependencies {
  package { 'gcc':
    ensure => 'installed',
  }

  package { 'gcc-c++':
    ensure => 'installed',
  }

  package { 'lynx':
    ensure => 'installed',
  }

  package { 'bison':
    ensure => 'installed',
  }

  package { 'tftp-server':
    ensure => 'installed',
  }
  package { 'make':
    ensure => 'installed',
  }

  package { 'ncurses-devel':
    ensure => 'installed',
  }

  package { 'compat-libtermcap':
    ensure => 'installed',
  }

  package { 'sendmail':
    ensure => 'installed',
  }

  package { 'sendmail-cf':
    ensure => 'installed',
  }

  #package { 'caching-nameserver':
  #  ensure => 'installed',
  #}

  package { 'sox':
    ensure => 'installed',
  }
  package { 'mpg123':
    ensure => 'installed',
  }
 
  package { 'newt-devel':
    ensure => 'installed',
  }
  package { 'libxml2-devel':
    ensure => 'installed',
  }
  package { 'libtiff-devel':
    ensure => 'installed',
  }
  package { 'audiofile-devel':
    ensure => 'installed',
  }
  package { 'gtk2-devel':
    ensure => 'installed',
  }
  package { 'subversion':
    ensure => 'installed',
  }

  package { 'kernel-devel':
    ensure => 'installed',
  }

  package { 'crontabs':
    ensure => 'installed',
  }

  package { 'cronie':
    ensure => 'installed',
    require => [ Exec['yum_base'], Package['crontabs'] ],
  }

  package { 'cronie-anacron':
    ensure => 'installed',
    require => [ Exec['yum_base'], Package['cronie'] ],
  }

  package { 'openssl-devel':
    ensure => 'installed',
  }
}
