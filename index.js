#!/usr/bin/env node
require('coffee-script/register');

env = process.env.NODE_ENV || 'development';
CmInstance = require('./lib/cm-instance');
CmModel = require('./lib/cm-model');

Cumono = function(){};
Cumono.Model = CmModel;
Cumono.init = function(dir){
  Cumono.appRoot = dir;
  Cumono.i = new CmInstance(dir, env);
  return Cumono;
}

module.exports = Cumono