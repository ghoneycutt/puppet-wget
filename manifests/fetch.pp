# == Define: wget::fetch
#
# This class will download file. You may define a web proxy using $http_proxy.
#
define wget::fetch (
  $source,
  $destination,
  $timeout = '0',
  $verbose = false,
) {

  include wget

  if $::osfamily == 'Solaris' {
    $default_path = '/usr/sfw/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
  } else {
    $default_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
  }

  # using "unless" with test instead of "creates" to re-attempt download
  # on empty files.
  # wget creates an empty file when a download fails, and then it wouldn't try
  # again to download the file
  if $::http_proxy {
    $environment = [ "HTTP_PROXY=${::http_proxy}", "http_proxy=${::http_proxy}" ]
  } else {
    $environment = []
  }

  $verbose_option = $verbose ? {
    true  => '--verbose',
    false => '--no-verbose'
  }

  exec { "wget-${name}":
    command     => "wget ${verbose_option} --output-document=${destination} ${source}",
    timeout     => $timeout,
    unless      => "test -s ${destination}",
    environment => $environment,
    path        => $default_path,
    require     => Class['wget'],
  }
}
