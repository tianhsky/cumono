_ = require("underscore")
CmModel = require('./cm-model')

class CmSequelizeAdapter

  constructor: (cmModel)->
    @model = cmModel

  translateModel: ->
    self = this
    
    SequelizeModel = (sequelize, DataTypes) ->
      modelName = self.model.name
      modelAttrs = self.model.modelAttrs(DataTypes)

      modelInstanceMethods = self.getInstanceMethods()
      modelClassMethods =
        associate: self.model.modelAssociations
      _.extend(modelClassMethods, self.getClassMethods())

      modelOptions = self.model.modelOptions()
      modelOptions.classMethods = modelClassMethods
      modelOptions.instanceMethods = modelInstanceMethods
      Model = sequelize.define(modelName, modelAttrs, modelOptions)

  getClassMethods: ->
    classMethods = {}
    excludeMethods = ["length","name","arguments","caller","prototype"]
    # excludeMethods = excludeMethods.concat(Object.getOwnPropertyNames(CmModel))
    names = Object.getOwnPropertyNames(@model)
    for name in names
      if name not in excludeMethods
        classMethods[name] = @model[name]
    classMethods

  getInstanceMethods: ->
    instanceMethods = {}
    excludeMethods = ["constructor"]
    # excludeMethods = excludeMethods.concat(Object.getOwnPropertyNames(CmModel.prototype))
    names = Object.getOwnPropertyNames(@model.prototype)
    for name in names
      if name not in excludeMethods
        instanceMethods[name] = @model.prototype[name]
    instanceMethods


module.exports = CmSequelizeAdapter