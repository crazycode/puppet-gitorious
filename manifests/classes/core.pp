class gitorious::core {

/*
	exec {
		'gitorious_chown':
			command => 'chown -R git:git /usr/share/gitorious',
			refreshonly => true,
			subscribe => Exec['git_pull_gitorious'];
	}
*/
		
	file {
		"$gitorious::home":
			ensure => directory,
			owner => "git",
			group => "git",
			recurse => true;

		"/bin/gitorious":
			target => "$gitorious::home/script/gitorious",
			ensure => symlink;

		"$gitorious::home/log": 
			ensure => directory,
			owner => "git",
			group => "git",
			mode => 0666,
			recurse => true;

		"$gitorious::home/tmp": 
			ensure => directory,
			owner => "git",
			group => "git",
			recurse => true;

		"$gitorious::home/tmp/tarballs": 
			ensure => directory,
			owner => "git",
			group => "git",
			require => File["$gitorious::home/tmp"]; 

		"$gitorious::home/tmp/pids": 
			ensure => directory,
			owner => "git",
			group => "git",
			require => File["$gitorious::home/tmp"];
	}
}
