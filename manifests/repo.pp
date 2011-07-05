class gitorious::repo {
    file {
		"dag-gpg-key":
			ensure => present,
			path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
			source => "puppet:///gitorious/keys/RPM-GPG-KEY-rpmforge-dag",
			owner => root,
			group => root;

		"inuits-gpg-key":
			ensure => present,
			path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-inuits",
			source => "puppet:///gitorious/keys/RPM-GPG-KEY-inuits",
			owner => root,
			group => root;
    }

    yumrepo {
		"DAG":
			descr => "RPMforge.net - dag",
			baseurl => absent,
			mirrorlist => "http://apt.sw.be/redhat/el5/en/mirrors-rpmforge",
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
			baseurl => "http://repo.inuits.be/centos/5/os",
			gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-inuits",
			gpgcheck => 0,
			require => File["inuits-gpg-key"];
	}
}
