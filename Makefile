.PHONY: build test

TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)

build: async-ext.js

async-ext.js: async-ext.coffee
	node_modules/coffee-script/bin/coffee --bare -c async-ext.coffee

test: $(TESTS)

$(TESTS): build
	@echo $(LIBS)
	node_modules/mocha/bin/mocha --bail --timeout 6000 --compilers coffee:coffee-script test/$@.coffee
