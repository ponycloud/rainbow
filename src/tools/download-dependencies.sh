#!/bin/bash

# Script to download (and optionally unpack) javascript libraries
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../components

# Angular.js
wget -nv -O angular.min.js \
		"http://code.angularjs.org/1.1.5/angular.min.js"

# jQuery
wget -nv -O jquery.min.js \
		"http://code.jquery.com/jquery-2.0.3.min.js"

# Angular-strap
wget -nv -O angular-strap.min.js \
		"http://raw.github.com/mgcrea/angular-strap/v0.7.5/dist/angular-strap.min.js"

# Angular-ui-bootstrap
wget -nv -O angular-ui-bootstrap-tpls.min.js \
		"https://github.com/angular-ui/bootstrap/blob/gh-pages/ui-bootstrap-tpls-0.5.0.min.js"

# Angular-i18n
wget -nv -O ng-i18next.min.js \
		"https://raw.github.com/archer96/ng-i18next/master/releases/v0.2.6/ng-i18next.min.js"

# Autobahn.js
wget -nv -O autobahn.js \
		"http://autobahn.s3.amazonaws.com/js/autobahn.min.js" -O autobahn.js

# Bootstrap
wget -nv -O bootstrap.zip \
		"http://getbootstrap.com/2.3.2/assets/bootstrap.zip"
unzip -u  bootstrap.zip
rm bootstrap.zip
