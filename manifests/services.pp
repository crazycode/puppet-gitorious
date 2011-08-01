class system::services {
    service { "sendmail":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
		name => $operatingsystem ? {
			Centos => $operatingsystemrelease ? {
				'6.0' => 'postfix',
				'*' => 'sendmail',
			},
			'*' => 'sendmail',
		},
    }  
}


class gitorious::services {

    file {
		"/etc/init.d/git-ultrasphinx":
			ensure => present,
			owner => "root",
			group => "root",
			mode => 755;
#			content => "/var/www/gitorious/doc/templates/centos/git-ultrasphinx",

		"/etc/init.d/git-daemon":
			ensure => present,
			owner => "root",
			group => "root",
			mode => 755;
#			content => "/var/www/gitorious/doc/templates/centos/git-ultrasphinx",
    }

/*
	service {
		"git-ultrasphinx":
			ensure => running,
			enable => true,
			hasstatus => true,
			hasrestart => true,
			require => File["/etc/init.d/git-ultrasphinx"];

		"git-daemon":
			ensure => running,
			enable => true,
			hasstatus => true,
			hasrestart => true,
			require => File["/etc/init.d/git-daemon"];
    }

    exec {
		"stompserver start &":
			command => "stompserver start &",
			cwd => "/root/",
			require => Service["git-daemon"];

		"script/poller":
			command => "script/poller start",
			cwd => "/var/www/gitorious",
			require => [Service["git-daemon"], File["/var/www/gitorious/tmp/pids"]];
    }
*/
}
