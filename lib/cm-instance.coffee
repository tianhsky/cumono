CmConfig = require('./cm-config')
CmSequelizeImporter = require('./cm-sequelize-importer')

class CmInstance

  constructor: (dir, env) ->
    @appRoot = dir
    @env = env
    @config = new CmConfig(dir, env)
    @setupDB()

  setupDB: ->
    importer = new CmSequelizeImporter(@config)
    @db = importer.getDB()
    @dao = @db
    @sequelize = @db.sequelize
    @Sequelize = @db.Sequelize
    @Promise = @sequelize.Promise

module.exports = CmInstance