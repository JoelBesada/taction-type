###
# WebSocket Server Setup
###
_ = require "underscore"
WebSocketServer = require("websocket").server
clients = {}
inputDeviceID = null

exports.init = (webServer) ->
  webSocketServer = new WebSocketServer
    httpServer: webServer
    autoAcceptConnections: false

  webSocketServer.on "request", (req) ->
      setupConnection req.accept(null, req.origin)

setupConnection = (connection) ->
  ID = _.uniqueId()

  clients[ID] =
    connection: connection

  connection.on "message", (message) ->
    # Allow only one connected device be registered as the input
    if message.utf8Data is "INPUT_DEVICE" and inputDeviceID is null
      console.log "New input device set: #{ID}"
      inputDeviceID = ID
      # Trigger a a newinput event on all other connections
      for clientID, client of clients
        continue if clientID is ID
        client.connection.sendUTF JSON.stringify(event: "newinput")

      return

    # Forward all messages to other clients
    for clientID, client of clients
      client.connection.sendUTF(message.utf8Data) unless clientID is ID

  connection.on "close", (reasonCode, description) ->
    delete clients[ID]
    # Allow a new input device to connect
    inputDeviceID = null if ID is inputDeviceID
