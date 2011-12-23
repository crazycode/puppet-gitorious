import 'classes/*'

class gitorious (
	$dbuser = 'gitorious',
	$dbpass = 'gitorious',
	$webserver = 'apache2',
	$home = '/usr/share/gitorious',
	$host
) {
  class {
    'apache':;
    'mysql':
      rootpass => 'foobar';
    'passenger':;
    'repos':;
  }

  class{'gitorious::pre':} ->
  class{'gitorious::repo':} ->
  class{'gitorious::depends':} ->
  class{'gitorious::user':} ->
  class{'gitorious::core':} ->
  class{'gitorious::config':} ->
  class{'gitorious::services':}

  Exec { path => '/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin' }
}
