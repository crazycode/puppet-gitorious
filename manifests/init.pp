import 'classes/*'

class gitorious (
	$dbuser = 'gitorious',
	$dbpass = 'gitorious',
	$webserver = 'apache2',
	$home = '/usr/share/gitorious',
	$stages = 'no',
	$host
) {
	if $stages != 'yes' {
		class{'gitorious::pre':} -> class{'gitorious::repo':} -> class{'gitorious::depends':} -> class{'gitorious::user':} -> class{'gitorious::core':} -> class{'gitorious::config':} -> class{'gitorious::services':}
	} else {
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

  class {
    'passenger':;
  }

  Exec { path => '/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin' }
}
