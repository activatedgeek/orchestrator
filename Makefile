##
# Variables can be overridden using -e
#
facts:
	@PLAYBOOK=refresh_cache.yml vagrant provision

provision:
	@make facts
	@vagrant provision
