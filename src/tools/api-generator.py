#!/usr/bin/python

import json
import requests
import sys



schema_url = sys.argv[2] + '/schema'
schema = requests.get(schema_url).content

api = json.loads(schema)

patch_api_classes = """
class Entity
  @serial: 0
  path: ''
  ops: []
  parent: null
  id: null
  pkey: null

  @_incrementSerial: -> Entity.serial++

  constructor: (@parent, @path, @id) ->
    if not @id
      @id = "%autoid#{ Entity.serial }"
      Entity.serial++

  _getPath: ->
    return @path

  _replaceId: (path, id) ->
    r = path.replace /%id/g, if id then id else @id
    r = r.replace "//", "/"
    return r

  _fixValue: (value, pkey, id) ->
    #if not value[pkey] and pkey
    #  value[pkey] = id

    return value

  _add: (op, path, value, pkey, id) ->
    value = @_fixValue value, pkey, id

    if @parent
      @parent._add op, @_replaceId(@_getPath()) + @_replaceId(path,id), value
    else
      @ops.push {
          op: op,
          path: @_replaceId(path,id),
          value: value
      }

  _remove: (path, id) ->
    if @parent
      @parent._remove @_replaceId(@_getPath()) + @_replaceId(path, id)
    else
      @ops.push {
        op: 'remove',
        path: @_replaceId(path, id)
      }

  _replace: (path, id, newData) ->
    if @parent
      @parent._replace @_replaceId(@_getPath()) + @_replaceId(path, id, newData), id, newData
    else
      @ops.push {
        op: 'replace',
        path: @_replaceId(path, id),
        value: newData
      }

  _merge: (path, id, newData) ->
    if @parent
      @parent._merge @_replaceId(@_getPath()) + @_replaceId(path, id, newData), id, newData
    else
      @ops.push {
        op: 'x-merge',
        path: @_replaceId(path, id),
        value: newData
      }
"""
def get_pkey(key):
	if not isinstance(key,list):
		return key

	return '[%s]' % ', '.join(map(lambda x: "'%s'" % x, key))

def class_name(name):
	return name.title().replace('-', '')

def safe_name(name):
	return '_' + name.replace('-', '')

def get_paths(api, path):
	results = []
	for key, val in api.iteritems():
		results.append(path + [key])
		if val['children']:
			results += get_paths(val['children'], path + [key] )
	return results

def get_entities(api, entities):
	for key, val in api.iteritems():
		if not key in entities:
			entities[key] = val
		else:
			if len(val['children']) > entities[key]['children']:
				entities[key] = val
		if val['children']:
			entities = get_entities(val['children'], entities)
	return entities

api_paths = get_paths(api, [])
entities = get_entities(api, {})

def generate_methods(objName, safeName, pkey, name):
	r  = '  add%s: (data, id) ->\n' % objName
	r += '    %s = new %s this, "/children/%s/%%id/"\n' % (safeName, objName, name)
	r += '    @_add "add", "/children/%s/%%id",data,"%s",%s.id\n' % (name,pkey,safeName)
	r += '    return %s\n' % safeName
	r += '\n'
	r += '  remove%s: (uuid) ->\n' % objName
	r += '    @_remove "/children/%s/%%id", uuid\n' % name
	r += '\n'
	r += '  replace%s: (uuid, newData) ->\n' % objName
	r += '    @_replace "/children/%s/%%id/desired", uuid, newData\n' % name
	r += '\n'
	r += '  merge%s: (uuid, newData) ->\n' % objName
	r += '    @_merge "/children/%s/%%id/desired", uuid, newData\n' % name
	r += '\n'
	r += '  %s: (id) ->\n' % objName
	r += '    return new %s this, "/children/%s/%%id/", id\n\n' % (objName, name)
	return r

def generate_class(objClass, children):
		objName = class_name(objClass)
		r =  '\nclass %s extends Entity\n' % objClass

		for name, api_object in children.iteritems():
			objName = class_name(name)
			safeName = safe_name(name)
			pkey = api_object['pkey']
			r += generate_methods(objName, safeName, pkey, name)

		return r


def make_patch_api():
    r = patch_api_classes

    for name, api_obj in entities.iteritems():
        r += generate_class(class_name(name), api_obj['children'])

    r += generate_class('Api', {})

    for path in api_paths:
        f_name = '  @patch' + ''.join([class_name(x) for x in path])
        f_args = '(%s)' % ', '.join([safe_name(x) for x in path])
        f_path = '/' + '/'.join(['%s/#{%s}' % (x, safe_name(x)) for x in path])+ '/'

        pkey = get_pkey(entities[path[-1]]['pkey'])
        pkey_value = safe_name(path[-1])
        c_name = class_name(path[-1])
        f_body = '    return new %s null, "%s", %s' % (c_name, f_path, pkey_value)

        ret = '%s: %s ->\n%s\n' % (f_name, f_args, f_body)

        r += ret

    r += 's = angular.module "rainbowPatchApi", []\n'
    r += 's.factory "Api", () -> return Api\n'

    return r

def make_services():

    r = 'toArray = (data) ->\n'
    r += '  _.toArray(JSON.parse(data))\n'
    r += 's = angular.module "rainbowServices"\n'
    r += 'methods = {"list":  {method:"GET", isArray:true, transformResponse: toArray}, "query": {method: "GET", isArray: true, transformResponse: toArray}}\n'
    r += 'options = {"stripTrailingSlashes": false}\n'

    for path in api_paths:
        name = ''.join([class_name(x) for x in path])
        url = '/' + '/'.join(['%s/:%s' % (x,x.replace('-','_')) for x in path])
        url = '#{WEB_URL}#{API_SUFFIX}' + url
        r += "s.factory \"%s\", ($resource, WEB_URL, WEB_PORT, API_SUFFIX) ->\n" % name
        r += "\t$resource(\"%s\", {}, methods, options)\n" % url

    return r




if __name__ == "__main__":
    if sys.argv[1] == "patch":
        print make_patch_api()

    elif sys.argv[1] == "services":
        print make_services()

