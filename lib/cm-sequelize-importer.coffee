path = require('path')
fs = require('fs')

Sequelize = require('sequelize')
Utils = require('sequelize/lib/utils')
DataTypes = require('sequelize/lib/data-types')
CmSequelizeAdapter = require('./cm-sequelize-adapter')
CmModel = require('./cm-model')

Sequelize::import = (filePath) ->
  # is it a relative path?
  if path.normalize(filePath) != path.resolve(filePath)
    # make path relative to the caller
    callerFilename = Utils.stack()[1].getFileName()
    callerPath = path.dirname(callerFilename)
    filePath = path.resolve(callerPath, filePath)
  if !@importCache[filePath]
    cmModel = if arguments.length > 1 then arguments[1] else require(filePath)
    if typeof cmModel == 'object' and cmModel.__esModule
      # Babel/ES6 module compatability
      cmModel = cmModel['default']

    if cmModel and cmModel.isCmModel
      sequelizeAdapter = new CmSequelizeAdapter(cmModel)
      defineCall = sequelizeAdapter.translateModel()
      @importCache[filePath] = defineCall(this, DataTypes)
      
  @importCache[filePath]


class CMSequelizeImporter

  ###
  Object that holds reference to database and models
  ###
  db = {}

  ###
  @param [CmConfig] config
  ###
  constructor: (config) ->
    @config = config
    dbConfig = @config.db()
    sequelize = new Sequelize(dbConfig.database, dbConfig.username, dbConfig.password, dbConfig)
    db.sequelize = sequelize
    db.Sequelize = Sequelize
    @importModels()

  ###
  Read all model files and store in db object
  ###
  importModels: ->
    dir = @config.modelsPath()
    fs.readdirSync(dir).filter((file) ->
      file.indexOf('.') != 0
    ).forEach (file) ->
      model = db.sequelize.import(path.join(dir, file))
      if model
        db[model.name] = model
        model.modelRegister(model)
      return
    Object.keys(db).forEach (modelName) ->
      if 'associate' of db[modelName]
        db[modelName].associate db
      return

  ###
  Get db object that contains reference to database and models
  @return [Object] db
    { sequelize, Sequelize, [modelNames] }
  ###
  getDB: ->
    db

module.exports = CMSequelizeImporter
