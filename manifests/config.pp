class gitorious::config {
    file {
		"/var/www/gitorious/config/database.yml":
			content => template("gitorious/database.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/var/www/gitorious/config/gitorious.yml":
			content => template("gitorious/gitorious.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/var/www/gitorious/config/broker.yml":
			content => template("gitorious/broker.yml.erb"),
			ensure => present,
			owner => "git",
			group => "git";

		"/var/www/gitorious/config/environments/production.rb":
			content => template("gitorious/production.rb.erb"),
			ensure => present;

		"/etc/ld.so.conf.d/gitorious.conf":
			path => "/etc/ld.so.conf.d/gitorious.conf",
			source => "puppet:///gitorious/gitorious.conf",
			owner => "root",
			group => "root";
	}

	exec {
/*
		"create_db":
			command => "rake db:create RAILS_ENV=production",
			cwd => "/var/www/gitorious/",
			require => File['/var/www/gitorious/config/database.yml', '/var/www/gitorious/config/gitorious.yml'];

		"migrate_db":
			command => "rake db:migrate RAILS_ENV=production",
			cwd => "/var/www/gitorious/";

		"bootstrap_sphinx":
			command => "rake ultrasphinx:bootstrap RAILS_ENV=production",
			cwd => "/var/www/gitorious/",
			require => [Notify["dependencies_done"], Exec["create_db"]],
			notify => Service["httpd"];
*/
		"ldconfig":
			command => "ldconfig",
			cwd => "/root/",
			refreshonly => true,
			require => Package[$package_list],
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
