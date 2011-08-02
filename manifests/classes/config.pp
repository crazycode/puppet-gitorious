class gitorious::config {
    file {
		"/usr/share/gitorious/config/database.yml":
			content => template("gitorious/database.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/usr/share/gitorious/config/gitorious.yml":
			content => template("gitorious/gitorious.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/usr/share/gitorious/config/broker.yml":
			content => template("gitorious/broker.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/usr/share/gitorious/config/environments/production.rb":
			content => template("gitorious/production.rb.erb"),
			ensure => present;

		"/etc/ld.so.conf.d/gitorious.conf":
			path => "/etc/ld.so.conf.d/gitorious.conf",
			content => template('gitorious/gitorious.conf.erb'),
			owner => "root",
			group => "root";
	}

	exec {
/*
		"create_db":
			command => "rake db:create RAILS_ENV=production",
			cwd => "/usr/share/gitorious/",
			require => File['/usr/share/gitorious/config/database.yml', '/usr/share/gitorious/config/gitorious.yml'];
*/

		"migrate_db":
			command => "rake db:setup RAILS_ENV=production",
			cwd => "/usr/share/gitorious/";

		"bootstrap_sphinx":
			command => "rake ultrasphinx:bootstrap RAILS_ENV=production",
			cwd => "/usr/share/gitorious/";
#			require => Exec["create_db"],
#			notify => Service["httpd"];

		"ldconfig":
			command => "ldconfig",
			cwd => "/root/",
			refreshonly => true,
			subscribe => [File["/etc/ld.so.conf.d/gitorious.conf"]];
	}

    line {
		"export_LD_LIBRARY_PATH":
			file => "/etc/profile",
			line => "export LD_LIBRARY_PATH=\"/usr/local/lib\"",
			ensure => present;

		"export_LDFLAGS":
			file => "/etc/profile",
			line => "export LDFLAGS=\"-L/usr/local/lib -Wl,-rpath,/usr/local/lib\"",
			ensure => present;
	}
}
