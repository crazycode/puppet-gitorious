class gitorious::notify {
	notify { "dependencies_done":
		message => "Gitorious dependencies installed. moving on",
		require => Stage['depends'],
	}

	notify {"gitorious_configured":
		message => "Finished configuring Gitorious",
#		require => Exec["bootstrap_sphinx"],
	}
}
