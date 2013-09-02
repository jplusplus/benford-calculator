http = require 'http'
path = require 'path'
express = require 'express'

routes = require './routes'

app = do express

app.set 'port', process.env.port || 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'ejs'

app.use express.logger 'dev'
app.use do express.bodyParser
app.use do express.methodOverride
app.use app.router
app.use (require 'less-middleware') { src: path.join __dirname, 'public' }
app.use express.static path.join __dirname, 'public'

app.use do express.errorHandler

app.get '/', routes.index

(http.createServer app).listen (app.get 'port'), () =>
	console.log 'Server is running ' + (app.get 'port')