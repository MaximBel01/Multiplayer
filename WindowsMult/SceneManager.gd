extends Node2D

@export var Characterscene:	 PackedScene

func _ready():
	var index =0
	for i in Gamemanager.Players:
		var currentplayer=Characterscene.instantiate()
		currentplayer.name=str(Gamemanager.Players[i].id)
		add_child(currentplayer)
		for spawn in get_tree().get_nodes_in_group("Spawns"):
			if spawn.name=="spawner"+str(index+1):
				currentplayer.global_position=spawn.global_position
		index+=1
	pass
