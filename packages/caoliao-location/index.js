// const _ = require('lodash')
const location = require('lib/location.json')

exports.location = location
exports.country = _.filter(location, function(d){ d.level === 1})
exports.state = _.filter(location, function(d){ d.level === 2})
exports.city = _.filter(location, function(d){ d.level === 3})
exports.region = _.filter(location, function(d){ d.level === 4})