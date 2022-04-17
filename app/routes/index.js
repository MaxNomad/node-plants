const noteRoutes = require('./doom_routes');

module.exports = function(app, db, woo) {
    noteRoutes(app, db, woo);
  };