module.exports = {
  apps : [{
    name   : "wp-server",
    script : "app.js",
    ignore_watch: ['node_modules'],
    watch: true,
    watch_delay: 3000,
    env_production: {
       NODE_ENV: "production"
    },
    env_development: {
       NODE_ENV: "development"
    }
  }]
}