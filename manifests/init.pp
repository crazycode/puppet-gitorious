import 'classes/*'

class gitorious (
	$dbuser = 'gitorious',
	$dbpass = 'gitorious'
) {
	class {
		'gitorious::pre':
			stage => pre;
		'gitorious::repo':
			stage => repo;
		'gitorious::depends':
			stage => depends;
		'gitorious::user':
			stage => core;
		'gitorious::core':
			stage => core;
		'gitorious::config':
			stage => config;
		'gitorious::services':
			stage => services;
	}
}
