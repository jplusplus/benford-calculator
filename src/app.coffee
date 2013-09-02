http = require 'http'
path = require 'path'
express = require 'express'

routes = require './routes'

#Instanciate Express app
app = do express

#Setup applications variables
app.set 'port', process.env.port || 3000
app.set 'views', path.join __dirname, 'templates'
app.set 'view engine', 'ejs'

#Setup middlewares
app.use express.logger 'dev'
app.use do express.bodyParser
app.use do express.methodOverride
app.use app.router
app.use ((require 'less-middleware') { src: path.join __dirname, 'static', 'stylesheets' })
app.use express.static path.join __dirname, 'static'

app.use do express.errorHandler

app.get '/', routes.index

#Launch server
(http.createServer app).listen (app.get 'port'), () =>
    console.log 'Server is running ' + (app.get 'port')