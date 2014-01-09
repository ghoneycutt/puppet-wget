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
      case $::kernelrelease {
        '5.9', '5.10': {
          $default_package = [ 'SUNWwgetr', 'SUNWwgetu' ]
        }
        '5.11': {
          $default_package = 'SUNWwget'
        }
        default: {
          fail("wget supports Solaris with kernelreleases 5.9, 5.10 and 5.11. Detected kernelrelease is <${::kernelrelease}>.")
        }
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
