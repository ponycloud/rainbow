.PHONY: js-libs patch-api services

js-libs:
	tools/download-dependencies.sh

patch-api:
	python ./tools/api-generator.py patch > common/api.coffee
	coffee -c common/api.coffee

services:
	python ./tools/api-generator.py services > common/services.coffee
	coffee -c common/services.coffee
