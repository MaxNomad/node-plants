require('dotenv').config();

const express = require('express');
const router = express.Router();
const app = express();
const mysql = require('mysql');
var cors = require('cors')
const WooCommerceRestApi = require('./app/woo-api');
const gracefulShutdown = require('http-graceful-shutdown');

const woo = new WooCommerceRestApi({
    url: process.env.url,
    consumerKey: process.env.consumerKey,
    consumerSecret: process.env.consumerSecret,
    version: "wc/v3"
});


app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors({
    origin: '*',
    exposedHeaders: ['Content-Length', 'X-Foo', 'X-Bar']
  }));
app.use('/api/v1', router);
const port = process.env.APP_PORT;
const pool = mysql.createPool({
    host: process.env.DB_host,
    user: process.env.DB_user,
    password: process.env.DB_password,
    database: process.env.DB_database,
    connectionLimit : 100

});


function shutdownFunction(signal) {
    return new Promise((resolve) => {
      console.log('Called signal: ' + signal);
      console.log('Server in cleanup')
      console.log('Database pool conection closed')
      pool.destroy()
      setTimeout(function() {
        console.log('Cleanup finished');
        resolve();
      }, 1000)
    });
  }
  function finalFunction() {
    console.log('Server shutted down')
    console.log('Date: ', Date())
  }
  
  gracefulShutdown(app,
    {
      signals: 'SIGINT SIGTERM',
      timeout: 10000,                  
      development: false,               
      forceExit: true,                  
      //preShutdown: preShutdownFunction, 
      onShutdown: shutdownFunction,     
      finally: finalFunction           
    }
  );


pool.getConnection(function (err) {
    if (err) {
        return console.error("Database error: " + err.message);
        
    }
    else {
        console.log("Database connected, pool created");
        require('./app/routes')(router, pool, woo);
        app.listen(port, process.env.APP_API,() => {
            console.log('App running on ' + port);
            console.log("App starts at:", Date());
        });
    }
});



