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
		"$home":
			ensure => directory,
			owner => "git",
			group => "git",
			recurse => true;

		"/bin/gitorious":
			target => "$home/script/gitorious",
			ensure => symlink;

		"$home/log": 
			ensure => directory,
			owner => "git",
			group => "git",
			mode => 0666,
			recurse => true;

		"$home/tmp": 
			ensure => directory,
			owner => "git",
			group => "git",
			recurse => true;

		"$home/tmp/tarballs": 
			ensure => directory,
			owner => "git",
			group => "git",
			require => File["$home/tmp"]; 

		"$home/tmp/pids": 
			ensure => directory,
			owner => "git",
			group => "git",
			require => File["$home/tmp"];
	}
}
