path = require('path')

class CmConfig

  constructor: (dir, env) ->
    @appRoot = dir
    @env = env
    @cache = {}

  app: (scopeByEnv=true) ->
    p = path.join(@appRoot, '/config/config.json')
    @cache.app = require(p) if !@cache.app
    return if scopeByEnv then @cache.app[@env] else @cache.app

  db: (scopeByEnv=true) ->
    p = path.join(@appRoot, '/config/database.json')
    @cache.db = require(p) if !@cache.db
    return if scopeByEnv then @cache.db[@env] else @cache.db

  modelsPath: ->
    p = path.join(@appRoot, '/app/models')

  protobufsPath: ->
    p = path.join(@appRoot, '/app/protobufs')

module.exports = CmConfig