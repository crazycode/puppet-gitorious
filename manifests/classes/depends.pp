class gitorious::depends {
	include gitorious::rpms
	include gitorious::gems
	include gitorious::source

	Class['gitorious::rpms'] -> Class['gitorious::source'] -> Class['gitorious::gems']
}

class gitorious::rpms {
    $package_list = ["apg",
					"sqlite-devel",
					"libjpeg-devel",
					"readline-devel",
					"pcre-devel",
					"zlib-devel",
					"openssl-devel",
					"libyaml-devel",
					"gcc",
					"gcc-c++",
					"autoconf",
					"automake",
					"git",
					"ruby-mysql",
					"djvulibre-devel",
					"jasper-devel",
					"librsvg2-devel.$hardwaremodel",
					"OpenEXR-devel.$hardwaremodel",
					"graphviz-devel.$hardwaremodel",
					"ghostscript",
					"freetype-devel",
					"libpng-devel",
					"giflib-devel",
					"libwmf-devel",
					"libexif-devel",
					"libtiff-devel",
					'ruby-shadow',
					'sphinx']

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

		'curl-devel':
			ensure => present,
			name => $operatingsystem ? {
				'Centos' => $operatingsystemrelease ? {
					'6.0' => 'libcurl-devel',
					'*' => 'curl-devel',
				},
				'*' => 'curl-devel',
			};
	}

	@package {
		"libtool-ltdl-devel":
			ensure => present,
	}

	if $operatingsystemrelease != '6.0' {
		realize(Package['libtool-ltdl-devel'])
	}
}

class gitorious::gems {
  $gems = ["mime-types",
#			"chronic",
			"facter",
#			"BlueCloth",
			"rmagick",
#			"geoip",
			"ultrasphinx",
			"rspec",
			"rspec-rails",
			'rvm',
#			"RedCloth",
#			"daemons",
#			"diff-lcs",
#			"highline",
#			"fastthread",
#			"hoe",
#			"oauth",
#			"rack",
#			"ruby-hmac",
#			"ruby-openid",
#			"ruby-yadis",
#			'json',
			'bundle']
#			'builder']

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
		provider => gem;
#		require => Package[$gems];
	}

/*
	gem {
		'rake':
			name => 'rake',
			version => '0.8.7';
	}
*/

	exec {
		'bundle install':
			command => 'bundle install',
			cwd => '/usr/share/gitorious';

		'remove rake-0.9.2':
			command => 'gem uni rake -v 0.9.2',
			path => '/bin:/sbin:/usr/bin:/usr/sbin',
			onlyif => 'gem list -l rake|grep "0.9.2"';
	}
}

class gitorious::source {
	exec {
		"git_pull_gitorious":
			command => "git clone git://gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/usr/share",
			creates => "/usr/share/gitorious",
			timeout => "-1";
	}
}
