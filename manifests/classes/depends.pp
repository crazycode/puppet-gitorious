class gitorious::depends {
    $package_list = [
					"apg",
					"sqlite-devel",
					"libjpeg-devel",
					"readline-devel",
					"pcre-devel",
					"zlib-devel",
					"openssl-devel",
					"libyaml-devel",
					"autoconf",
					"automake",
					"git",
					"ruby-mysql",
					"djvulibre-devel",
					"jasper-devel",
					"librsvg2-devel.$::hardwaremodel",
					"OpenEXR-devel.$::hardwaremodel",
					"graphviz-devel.$::hardwaremodel",
					"ghostscript",
					"freetype-devel",
					"libpng-devel",
					"giflib-devel",
					"libwmf-devel",
					"libexif-devel",
					"libtiff-devel",
					'ruby-shadow',
					'sphinx',
					'activemq',
	]

	package {
		$package_list:
			require => [ Class['mysql::packages'], Yumrepo['inuits-gems'] ],
			ensure => installed;
    
		'oniguruma':
			ensure => latest,
			name => "oniguruma.$::hardwaremodel",
			require => Package[$package_list];

		'oniguruma-devel':
			ensure => latest,
			name => "oniguruma-devel.$::hardwaremodel",
			require => Package['oniguruma'];

		'imagemagick':
			name => "ImageMagick.$::hardwaremodel",
			ensure => latest;

		'imagemagick-devel':
			name => "ImageMagick-devel.$::hardwaremodel",
			ensure => latest,
			require => Package["imagemagick"];

		'rake':
			ensure => '0.9.2',
			before => Exec['install modules', 'bundle_install'],
			provider => gem;

		'bundler':
			ensure => present,
			provider => gem;
	}

	@package {
		"libtool-ltdl-devel":
			ensure => present,
	}

	if $::operatingsystemrelease != '6.0' {
		realize(Package['libtool-ltdl-devel'])
	}

	exec {
		'bundle_install':
			command => 'bundle install',
			cwd => '/usr/share/gitorious',
			before => File["$gitorious::home"],
			require => Exec['git_pull_gitorious'];

		"git_pull_gitorious":
			command => "git clone git://gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/usr/share",
			creates => "/usr/share/gitorious/public",
			before => File["$gitorious::home"],
			require => Package[$package_list],
			timeout => "-1";
	}
}
