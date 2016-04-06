CmConfig = require('./cm-config')
CMProtobufImporter = require('./cm-protobuf-importer')
CmSequelizeImporter = require('./cm-sequelize-importer')

class CmInstance

  constructor: (dir, env) ->
    @appRoot = dir
    @env = env
    @config = new CmConfig(dir, env)
    @setupProtobuf()
    @setupDB()

  setupDB: ->
    importer = new CmSequelizeImporter(@config)
    @db = importer.getDB()
    @dao = @db
    @sequelize = @db.sequelize
    @Sequelize = @db.Sequelize
    @Promise = @sequelize.Promise
  
  setupProtobuf: ->
    importer = new CMProtobufImporter(@config)
    @protobuf = importer.getBuilder()

module.exports = CmInstance