class gitorious::pre {
    exec {
		"yum-update":
	        command => "yum -y update",
	        cwd => "/root/",
	        refreshonly => true,
	        timeout => 20000;

		remove_32:
			command => 'sudo yum -y remove *.i*86',
			onlyif => "yum list installed|grep '.i.86'";
	}
}
