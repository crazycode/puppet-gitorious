import 'classes/*'

class gitorious {
	include gitorious::config
	include gitorious::core
	include gitorious::depends
	include gitorious::passenger
	include gitorious::pre
	include gitorious::repo
	include gitorious::services
	include gitorious::user
	include system::services

	Class['gitorious::pre'] -> Class['gitorious::repo'] -> Class['gitorious::depends'] -> Class['core'] -> Class['gitorious::config'] -> Class['gitorious::user'] -> Class['gitorious::passenger'] -> Class['system::services'] -> Class['gitorious::services']
}
