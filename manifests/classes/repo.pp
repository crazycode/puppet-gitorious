class gitorious::repo {
    @file {
		"dag-gpg-key":
			ensure => present,
			path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
			source => "puppet:///gitorious/keys/RPM-GPG-KEY-rpmforge-dag",
			owner => root,
			group => root;

		'inuits-gpg-key':
			ensure => present,
			path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-inuits",
			source => "puppet:///gitorious/keys/RPM-GPG-KEY-inuits.new",
			owner => root,
			group => root;

		"inuits-gpg-key.old":
			ensure => present,
			path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-inuits",
			source => "puppet:///gitorious/keys/RPM-GPG-KEY-inuits.old",
			owner => root,
			group => root;
    }

    @yumrepo {
		"rpmforge":
			descr => "rpmforge",
			baseurl => absent,
			mirrorlist => $operatingsystemrelease ? {
				'5.*' => "http://apt.sw.be/redhat/el5/en/mirrors-rpmforge",
				'6.0' => "http://apt.sw.be/redhat/el6/en/mirrors-rpmforge",
			},
			enabled => 1,
			gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
			gpgcheck => 1,
			priority => 1,
			require => File["dag-gpg-key"];

		"centosplus":
			baseurl => absent,
			mirrorlist => "http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus",
			enabled => 0,
			gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5",
			priority => 1;

		"inuits":
			descr => "Inuits internal repo",
			enabled => 1,
			baseurl => $operatingsystemrelease ? {
				'5.*' => "http://repo.inuits.be/centos/5/os",
				'6.0' => "http://repo.inuits.be/centos/6/os",
			},
			gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-inuits",
			gpgcheck => 1,
			require => File["inuits-gpg-key"];

		'inuits-gems':
			baseurl => 'http://repo.inuits.be/gems',
			descr => 'inuits internal gems repo',
			gpgcheck => 0,
			enabled => 1;			
	}

	if $operatingsystem == 'Centos' {
		if $operatingsystemrelease != '6.0' {
			realize(Yumrepo['centosplus'])
		}
		realize(File['dag-gpg-key', 'inuits-gpg-key'], Yumrepo['rpmforge', 'inuits', 'inuits-gems'])
	}
}
