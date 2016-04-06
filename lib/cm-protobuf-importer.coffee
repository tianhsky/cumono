path = require("path")
fs = require('fs')
ProtoBuf = require("protobufjs")

class CMProtobufImporter

  ###
  Object that holds reference to protobuf
  ###
  builder = {}

  ###
  @param [CmConfig] config
  ###
  constructor: (config) ->
    @config = config
    @importProtobufs()

  ###
  Read all model files and store in builder object
  ###
  importProtobufs: ->
    dir = @config.protobufsPath()
    console.log dir
    fs.readdirSync(dir).filter((file) ->
      file.indexOf('.') != 0
    ).forEach (file) ->
      builder = ProtoBuf.loadProtoFile(path.join(dir, file));

  ###
  Get builder object
  @return [Object] builder
  ###
  getBuilder: ->
    builder

module.exports = CMProtobufImporter