class gitorious::passenger {
    exec {"passenger-install-apache2-module":
        command => "passenger-install-apache2-module --auto",
        subscribe => Package["passenger"],
        creates => "/usr/lib/ruby/gems/1.8/gems/passenger-2.2.7/ext/apache2/mod_passenger.so",
    }

    $libdir = $architecture?{
      x86_64 => "lib64",
      default => "lib",
    }

    file {"passenger.conf":
        path => "/etc/httpd/conf.d/passenger.conf",
        content => template("gitorious/passenger.conf.erb"),
        ensure => present,
        owner => "root",
        group => "root",
        require => Exec["passenger-install-apache2-module"],
        notify => Service["httpd"]
    }
}
