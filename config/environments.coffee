###
# Environment Configuration
###
exports.init = (app, express) ->

  # General
  app.configure ->
    app.use express.logger "dev"
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use app.router
    app.use require("connect-assets")()
    app.use express.static("#{__dirname}/../public")

    app.set "port", process.env.PORT or 3000
    app.set "views", "#{__dirname}/../views"
    app.set "view engine", "ejs"

  # Development
  app.configure "development", ->
    app.use express.errorHandler()
    app.set "port", process.env.PORT or 4000
