class gitorious::core {

	exec {
		'gitorious_chown':
			command => 'chown -R git:git /usr/share/gitorious',
			refreshonly => true,
			subscribe => Exec['git_pull_gitorious'];
	}
		
	file {
		"/var/www/gitorious":
			ensure => directory,
			owner => "git",
			group => "git";
#			recurse => true,

		"/usr/local/bin/gitorious":
			target => "/var/www/gitorious/script/gitorious",
			ensure => symlink;

		"/var/www/gitorious/public/.htaccess": 
			ensure => absent;

		"/var/www/gitorious/log": 
			ensure => directory,
			owner => "git",
			group => "git",
			mode => 0666,
			recurse => true;

		"/var/www/gitorious/tmp": 
			ensure => directory,
			owner => "git",
			group => "git";
#			recurse => true,

		"/var/www/gitorious/tmp/tarballs": 
			ensure => directory,
			owner => "git",
			group => "git";
#			require => File["/var/www/gitorious/tmp"], 

		"/var/www/gitorious/tmp/pids": 
			ensure => directory,
			owner => "git",
			group => "git";
#			require => File["/var/www/gitorious/tmp"],
	}
}
