class gitorious::depends {
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
					'sphinx',
					'rubygem-rake',
					'rubygem-SystemTimer',
					'rubygem-activesupport',
					'rubygem-activemessaging',
					'rubygem-activerecord',
					'rubygem-acts-as-taggable-on',
					'rubygem-builder',
					'rubygem-json',
					'rubygem-capillary',
					'rubygem-chronic',
					'rubygem-daemons',
					'rubygem-diff-lcs',
					'rubygem-gemcutter',
#					'rubygem-json_pure',
#					'rubygem-rubyforge',
#					'rubygem-echoe',
					'rubygem-eventmachine',
					'rubygem-exception_notification',
					'rubygem-factory_girl',
					'rubygem-geoip',
					'rubygem-hodel_3000_compliant_logger',
					'rubygem-hoe',
					'rubygem-mime-types',
					'rubygem-mocha',
					'rubygem-mysql',
					'rubygem-oauth',
					'rubygem-paperclip',
					'rubygem-proxymachine',
					'rubygem-rack',
					'rubygem-rdiscount',
					'rubygem-redis',
					'rubygem-redis-namespace',
					'rubygem-sinatra',
					'rubygem-vegas',
					'rubygem-resque',
					'rubygem-revo-ssl_requirement',
					'rubygem-riddle',
					'rubygem-ruby-hmac',
					'rubygem-ruby-openid',
					'rubygem-ruby-yadis',
					'rubygem-shoulda',
					'rubygem-state_machine',
					'rubygem-stomp',
					'rubygem-tuxml',
					'rubygem-validates_url_format_of',
					'rubygem-will_paginate',
					]

	package {
		$package_list:
			require => $gitorious::stages ? {
				'yes' => Class['mysql::packages'],
				'no' => [ Class['mysql::packages'], Yumrepo['inuits-gems'] ],
			},
/*
			before => $gitorious::stages ? {
				'yes' => undef,
				'no' => Yumrepo['epel'],
			},
*/
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

		'json_pure':
			ensure => '1.5.1',
			provider => gem;

		'rubyforge':
			ensure => '2.0.4',
			provider => gem;

		'echoe':
			ensure => '3.2',
			provider => gem;
	}

	@package {
		"libtool-ltdl-devel":
			ensure => present,
	}

	if $operatingsystemrelease != '6.0' {
		realize(Package['libtool-ltdl-devel'])
	}

	exec {
		'remove rake-0.9.2':
			command => 'gem uni rake -v 0.9.2',
			path => '/bin:/sbin:/usr/bin:/usr/sbin',
#			require => Exec['install modules'],
			onlyif => 'gem list -l rake|grep "0.9.2"';

		"git_pull_gitorious":
			command => "git clone git://gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/usr/share",
			creates => "/usr/share/gitorious/public",
			before => $gitorious::stages ? {
				'no' => File["$home"],
				default => undef,
			},
			timeout => "-1";
	}
}
