##
# Variables can be overridden using -e
#

##
# Run registrator on each Mesos slave
# Enables service discovery across cluster
#
registrator:
	$(eval MARATHON_HOST=http://marathon.service.consul)
	@curl -X POST -H "Content-Type: application/json"\
		-d @"marathon-apps/registrator.json"\
		$(MARATHON_HOST)/v2/apps
