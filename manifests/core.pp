class gitorious::core {

	exec {
		'gitorious_chown':
			command => 'chown -R git:git /var/www/gitorious',
			refreshonly => true,
			subscribe => Exec['git_pull_gitorious'],
	}
		
	file { "/var/www/gitorious":
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
	}

	file {"/usr/local/bin/gitorious":
		target => "/var/www/gitorious/script/gitorious",
		ensure => symlink,
	}

	file {"/var/www/gitorious/public/.htaccess": 
		ensure => absent,
	}

	file {"/var/www/gitorious/log": 
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
	}

	file {"/var/www/gitorious/tmp": 
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
	}

	file {"/var/www/gitorious/tmp/tarballs": 
		ensure => directory,
		owner => "git",
		group => "git",
#		require => File["/var/www/gitorious/tmp"], 
	}

	file {"/var/www/gitorious/tmp/pids": 
		ensure => directory,
		owner => "git",
		group => "git",
#		require => File["/var/www/gitorious/tmp"],
	}
}
