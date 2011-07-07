class gitorious::config {
    file {"/var/www/gitorious/config/database.yml":
        content => template("gitorious/database.yml.erb"),
        ensure => present,
#        require => Exec["git_pull_gitorious"],
        owner => "git",
        group => "git",
    }

    file {"/var/www/gitorious/config/gitorious.yml":
        content => template("gitorious/gitorious.yml.erb"),
        ensure => present,
        owner => "git",
        group => "git",
#        require => Exec["git_pull_gitorious"],
    }

    file {"/var/www/gitorious/config/broker.yml":
        content => template("gitorious/broker.yml.erb"),
        ensure => present,
        owner => "git",
        group => "git",
#        require => Exec["git_pull_gitorious"],
    }

    $mail_server = "smtp.google.com"
    file {"/var/www/gitorious/config/environments/production.rb":
        content => template("gitorious/production.rb.erb"),
        ensure => present,
#        require => Exec["git_pull_gitorious"],
    }

    exec {"create_db":
        command => "rake db:create RAILS_ENV=production",
        cwd => "/var/www/gitorious/",
#        require => [Stage['depends'], File['/var/www/gitorious/config/database.yml', '/var/www/gitorious/config/gitorious.yml']],

    }

    exec {"migrate_db":
        command => "rake db:migrate RAILS_ENV=production",
        cwd => "/var/www/gitorious/",
        path => "/usr/bin",
#        require => [Stage['depends'], Exec['create_db']],
        #TODO: figure out the unless condition; otherwise the db will get overwritten periodically
    }

    exec {"bootstrap_sphinx":
        command => "rake ultrasphinx:bootstrap RAILS_ENV=production",
        cwd => "/var/www/gitorious/",
#        require => [Notify["dependencies_done"], Exec["create_db"]],
#        notify => Service["httpd"],
    }

	exec { "Change_MySQL_server_root_password":
#		subscribe => [ Package["mysql-server"], Package["mysql-devel"], Service["mysqld"]],
#		refreshonly => true,
		unless => "mysqladmin -uroot -p$mysql_password status",
		path => "/bin:/usr/bin",
		command => "mysqladmin -uroot password $mysql_password",
#		require => Service["mysqld"],
	}

    line { "export_LD_LIBRARY_PATH":
        file => "/etc/profile",
        line => "export LD_LIBRARY_PATH=\"/usr/local/lib\"",
        ensure => present,
    }

    line { "export_LDFLAGS":
        file => "/etc/profile",
        line => "export LDFLAGS=\"-L/usr/local/lib -Wl,-rpath,/usr/local/lib\"",
        ensure => present,
    }

    file {"/etc/ld.so.conf.d/gitorious.conf":
        path => "/etc/ld.so.conf.d/gitorious.conf",
        source => "puppet:///gitorious/gitorious.conf",
        owner => "root",
        group => "root",
    }

    exec {"ldconfig":
        command => "ldconfig",
        cwd => "/root/",
        refreshonly => true,
#        require => Package[$package_list],
        subscribe => [File["/etc/ld.so.conf.d/gitorious.conf"]],
    }
}
