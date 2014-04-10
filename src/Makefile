.PHONY: js-libs patch-api services

WEB_URL = $(shell grep WEB_URL common/services/config.coffee | cut -d\' -f 4)
SCHEMA_LOCATION = $(WEB_URL)$(shell grep API_SUFFIX common/services/config.coffee | cut -d\' -f 4)

js-libs:
	tools/download-dependencies.sh

patch-api:
	python ./tools/api-generator.py patch $(SCHEMA_LOCATION) > common/api.coffee
	coffee -c common/api.coffee

services:
	python ./tools/api-generator.py services $(SCHEMA_LOCATION) > common/services.coffee
	coffee -c common/services.coffee
