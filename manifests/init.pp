# deploy gitorious (http://www.gitorious.com) on a server
# based on [gitorious]/doc/recipes/centos5.2 document, with additions
#

import "config.pp"
import "core.pp"
import "depends.pp"
import "notify.pp"
import "passenger.pp"
import "pre.pp"
import "repo.pp"
import "services.pp"
import "user.pp"
import "utils.pp"

class gitorious {
	include gitorious::pre
	include gitorious::config
	include gitorious::core
	include gitorious::depends
	include gitorious::passenger
	include gitorious::repo
	include gitorious::services
	include gitorious::user
	include gitorious::utils
}
