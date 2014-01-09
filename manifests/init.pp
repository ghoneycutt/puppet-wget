# == Class: wget
#
# This class will install wget - a tool used to download content.
#
class wget (
  $version = 'installed',
) {

  case $::osfamily {
    'Darwin': { }
    'Debian', 'RedHat', 'Suse': {
      $default_package = 'wget'
    }
    'Solaris': {
      if $::kernelrelease == '5.11' {
        $default_package = 'SUNWwget'
      } else {
        $default_package = [ 'SUNWwgetr', 'SUNWwgetu' ]
      }
    }
    default: {
      fail("wget supports osfamilies Darwin, Debian, RedHat, Solaris and Suse. Detected osfamily is <${::osfamily}>.")
    }
  }

  if $::osfamily != 'Darwin' {
    package { 'wget':
      ensure => $version,
      name   => $default_package,
    }
  }
}
