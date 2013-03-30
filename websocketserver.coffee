###
# WebSocket Server Setup
# WebSockets are used within the application to communicate with
# other connected devices. Only one input device can be active
# at a time, all other devices act as "audience" devices.
#
# Communication between devices is handled by sending a JSON
# object with an event and data field. These events will then
# be triggered on all receiving applications, like any other
# JavaScript event.
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
  # Give a unique ID to every connected device
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
