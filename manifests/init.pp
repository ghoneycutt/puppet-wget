################################################################################
# Class: wget
#
# This class will install wget - a tool used to download content from the web.
#
################################################################################
class wget (
  $version = 'installed',
) {
  case $::osfamily {
    'RedHat', 'Debian': {
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
      fail( "wget package didn't available for your system" )
    }
  }
    package { 'wget':
      name => $default_package,
      ensure  => $version,
    }
}
