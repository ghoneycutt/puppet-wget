A Puppet module to download files with wget, supporting authentication.

# OS Support
The following osfamilies are supported.

* Debian
* EL
* Suse
* Solaris 9-11

# Example

	include wget

	wget::fetch { "download":
	  source      => "http://www.google.com/index.html",
	  destination => "/tmp/index.html",
	  timeout     => 0,
	  verbose     => false,
	}

	wget::authfetch { "download":
	  source      => "http://www.google.com/index.html",
	  destination => "/tmp/index.html",
	  user        => "user",
	  password    => "password",
	  timeout     => 0,
	  verbose     => false,
	}
