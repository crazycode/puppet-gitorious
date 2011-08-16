class gitorious::depends {
	class{'gitorious::rpms':} -> class{'gitorious::source':} -> class{'gitorious::gems':}
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
			require => Class['mysql::packages'],
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
	$gems = [
		'abstract',
		'actionpack',
		'activemessaging',
		'activemodel',
		'activerecord',
		'activesupport',
		'acts-as-taggable-on',
		'arel',
		'builder',
		'bundle',
		'bundler',
		'capillary',
		'chronic',
		'daemons',
		'diff-lcs',
		'echoe',
		'erubis',
		'eventmachine',
		'exception_notification',
		'facter',
		'factory_girl',
		'fastthread',
		'gemcutter',
		'geoip',
		'highline',
		'hodel_3000_compliant_logger',
		'hoe',
		'i18n',
		'json',
		'json_pure',
		'mime-types',
		'mocha',
		'mysql',
		'oauth',
		'oniguruma',
		'paperclip',
		'passenger',
		'plist',
		'proxymachine',
		'rack',

#		"BlueCloth",
		"rmagick",
		"ultrasphinx",
		"rspec",
		"rspec-rails",
		'rvm'
#		"RedCloth",
#		"ruby-hmac",
#		"ruby-openid",
#		"ruby-yadis",
	]

  package {
/*
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
*/
	'bundle':
		ensure => latest,
		provider => gem;
	}

	exec {
		'bundle install':
			command => 'bundle install',
#			before => Exec['install modules'],
			cwd => '/usr/share/gitorious';

		'remove rake-0.9.2':
			command => 'gem uni rake -v 0.9.2',
			path => '/bin:/sbin:/usr/bin:/usr/sbin',
#			require => Exec['install modules'],
			onlyif => 'gem list -l rake|grep "0.9.2"';
	}
}

class gitorious::source {
	exec {
		"git_pull_gitorious":
			command => "git clone git://gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/usr/share",
			creates => "/usr/share/gitorious/public",
			before => File["$home"],
			timeout => "-1";
	}
}
