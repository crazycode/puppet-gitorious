class dbconf {
	mysql_db { 'gitorious_production':
		name => 'gitorious_production',
		user => 'gitorious',
		pass => 'gitorious',
	}

	mysql_user { 'gitorious':
		name => "gitorious",
		pass => "gitorious",
		before => Mysql_db['gitorious_production'],
	}
}
