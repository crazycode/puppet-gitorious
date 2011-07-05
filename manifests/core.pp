class gitorious::core {

	exec {
		"git_pull_gitorious":
			command => "git clone http://git.gitorious.org/gitorious/mainline.git gitorious",
			cwd => "/var/www",
			creates => "/var/www/gitorious",
			timeout => "-1";

		'gitorious_chown':
			command => 'chown -R git:git /var/www/gitorious',
#			unless => 'if [[ `ls -l /var/www|grep gitorious|cut -d " " -f 3` == "git" ]]; then exit ;else exit ;fi',
			subscribe => Exec['git_pull_gitorious'],
#			require => Exec['git_pull_gitorious'];
	}
		
	file { "/var/www/gitorious":
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
#		require => Exec["git_pull_gitorious"]
	}

	file {"/usr/local/bin/gitorious":
		target => "/var/www/gitorious/script/gitorious",
		ensure => symlink,
#		require => Exec["git_pull_gitorious"],
	}

	file {"/var/www/gitorious/public/.htaccess": 
		ensure => absent,
#		require => Exec["git_pull_gitorious"],
	}

	file {"/var/www/gitorious/log": 
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
#		require => Exec["git_pull_gitorious"],
	}

	file {"/var/www/gitorious/tmp": 
		ensure => directory,
		owner => "git",
		group => "git",
#		recurse => true,
#		require => Exec["git_pull_gitorious"],
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
