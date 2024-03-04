module.exports = {
  apps : [{
    name   : "wp-server",
    exec_mode: 'cluster',
    instances: '2',
    script : "app.js",
    env_production: {
       NODE_ENV: "production"
    },
    env_development: {
       NODE_ENV: "development"
    }
  }]
}