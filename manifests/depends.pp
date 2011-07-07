class gitorious::depends {
	include gitorious::rpms
	include gitorious::gems
	include gitorious::source
}

class gitorious::rpms {
    $package_list = ["apg", "httpd-devel", "sqlite-devel", "libjpeg-devel", "readline-devel", "curl-devel", "pcre-devel", "zlib-devel", "openssl-devel", "libyaml-devel", "gcc", "gcc-c++", "autoconf", "automake", "mysql", "mysql-devel", "mysql-server", "git", "ruby-mysql", "djvulibre-devel", "jasper-devel", "libtool-ltdl-devel", "librsvg2-devel.$hardwaremodel", "OpenEXR-devel.$hardwaremodel", "graphviz-devel.$hardwaremodel", "ghostscript", "freetype-devel", "libpng-devel", "giflib-devel", "libwmf-devel", "libexif-devel", "libtiff-devel", 'sphinx']

	package {
		$package_list:
			ensure => installed;
    
		'oniguruma':
			ensure => latest,
			name => "oniguruma.$hardwaremodel",
			require => Package[$package_list];

		'oniguruma-devel':
			ensure => latest,
			name => "oniguruma-devel.$hardwaremodel",
			require => Package['oniguruma'];

		'imagemagick':
			name => "ImageMagick.$hardwaremodel",
			ensure => latest;

		'imagemagick-devel':
			name => "ImageMagick-devel.$hardwaremodel",
			ensure => latest,
			require => Package["imagemagick"];
	}
}

class gitorious::gems {
  $gems = ["mime-types", "chronic", "facter", "BlueCloth", "ruby-yadis", "ruby-openid", "rmagick", "geoip", "ultrasphinx", "rspec", "rspec-rails", "RedCloth", "daemons",  "diff-lcs", "highline", "fastthread", "hoe", "oauth","rack", "rake", "ruby-hmac", 'json']

  package {
	$gems:
    	ensure => installed,
    	provider => gem;
#    	require => [Package[$package_list], Package['oniguruma'], Exec["gem_update"]];

	'textpow':
		ensure => present,
		provider => gem,
		require => Package['oniguruma-devel'];

	"echoe":
    	provider => gem,
    	ensure =>"3.2";
#    	require => Package[$gems];

	"rdiscount":
    	ensure => "1.3.1.1",
    	provider => gem;
#    	require => Package[$gems];

	"stomp":
    	ensure => "1.1",
    	provider => gem;
#    	require => Package[$gems];

	"passenger":
    	ensure => "2.2.7",
    	provider => gem;
#    	require => Package[$gems];

	'puppet':
		ensure => latest,
		provider => gem,
#		require => Package[$gems];
  }
}

class gitorious::source {
		"git_pull_gitorious":
			command => "git clone https://git.gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/var/www",
			creates => "/var/www/gitorious",
			timeout => "-1";
}
