# == Define: wget::authfetch
#
# This class will download files. You may define a web proxy using
# $::http_proxy. Username must be provided. And the user's password must be
# stored in the password variable within the .wgetrc file.
#
define wget::authfetch (
  $source,
  $destination,
  $user,
  $password = '',
  $timeout  = '0',
  $verbose  = false,
) {

  include wget

  if $::osfamily == 'Solaris' {
    $default_path = '/usr/sfw/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
  } else {
    $default_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
  }

  if $::http_proxy {
    $environment = [ "HTTP_PROXY=${::http_proxy}", "http_proxy=${::http_proxy}", "WGETRC=/tmp/wgetrc-${name}" ]
  }
  else {
    $environment = [ "WGETRC=/tmp/wgetrc-${name}" ]
  }

  $verbose_option = $verbose ? {
    true  => '--verbose',
    false => '--no-verbose'
  }

  case $::operatingsystem {
    'Darwin': {
      # This is to work around an issue with macports wget and out of date CA cert bundle.  This requires
      # installing the curl-ca-bundle package like so:
      #
      # sudo port install curl-ca-bundle
      $wgetrc_content = "password=${password}\nCA_CERTIFICATE=/opt/local/share/curl/curl-ca-bundle.crt\n"
    }
    default: {
      $wgetrc_content = "password=${password}"
    }
  }

  file { "/tmp/wgetrc-${name}":
    owner   => 'root',
    mode    => '0600',
    content => $wgetrc_content,
    before  => Exec["wget-${name}"],
  }

  exec { "wget-${name}":
    command     => "wget ${verbose_option} --user=${user} --output-document=${destination} ${source}",
    timeout     => $timeout,
    unless      => "test -s ${destination}",
    environment => $environment,
    path        => $default_path,
    require     => Class['wget'],
  }
}
