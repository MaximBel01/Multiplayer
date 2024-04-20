extends Control
@export var adress="127.0.0.1"
@export var port = 8910
var peer = ENetMultiplayerPeer.new()
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisonnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass
	
func hostGame():
	var error = peer.create_server(port, 4)
	if error != OK:
		print("can't host: "+ error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players..")
	SendPlayerInformation($LineEdit.text,multiplayer.get_unique_id())
	pass # Replace with function body.
#serv+client
func PlayerConnected(id):
	print("Player connected "+str(id))
#serv+client	
func PlayerDisonnected(id):
	print("Player disconnected "+str(id))
	Gamemanager.Players.erase(id)
	var players=get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name==str(id):
			i.queue_free()
	
#only clients	
func ConnectedToServer():
	print("Connected! ")
	SendPlayerInformation.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !Gamemanager.Players.has(id):
		Gamemanager.Players[id]={
			"name":name,
			"id":id,
			"score":0
		}
	if multiplayer.is_server():
		for i in Gamemanager.Players:
			SendPlayerInformation.rpc(Gamemanager.Players[i].name,i)
#only clients	
func ConnectionFailed():
	print("Connection failed :c")
	
	
@rpc("any_peer","call_local")	
func StartGame():
	var scene = load("res://node_2d.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()	
	
	

	
func _on_host_button_down():
	hostGame()
	pass


func _on_join_button_down():
	peer=ENetMultiplayerPeer.new()
	peer.create_client(adress,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_button_down():
	StartGame.rpc()
	pass # Replace with function body.
