extends Control
# This script contains session creation logic

# Path to networking menu UI module
@export_file("*.tscn") var networking_menu_path : String
@onready var networking_menu : PackedScene = load(networking_menu_path)

# select appropriate node via the editor, gets user input
@export_node_path("Label") var logger_path : NodePath
@export_node_path("LineEdit") var match_name_path : NodePath
@export_node_path("Tree") var matches_ui_path : NodePath

# used to provide feedback to the user
@onready var logging : Label = get_node(logger_path)

# used to create matches
@onready var match_name_input : LineEdit = get_node(match_name_path)
@onready var matches : Tree = get_node(matches_ui_path)


func _ready() -> void:
	update_socket_status()

#TODO: write UI update logic
func update_matches() -> void:
	# get existing matches from Nakama, returns as a list?
	pass
	
	
# Check the status of the Network.socket and update UI elements
func update_socket_status():	
	# if the socket is connected
	if Networking.is_socket_connected():
		# give the player further feedback
		logging.text = "Socket available"	
	else:
		logging.text = "You must create a new socket connection"	


func _on_create_bridge_pressed() -> void:
	# attempt to create a new socket
	var success = await Networking.create_socket(Networking._client, Networking._session, logging)
	
	if success:
		# also set the multiplayer bridge
		Networking.set_multiplayer_bridge(Networking._socket, logging)

#TODO: tell nakama to create a match
func _on_create_match_pressed() -> void:
	# Call match_manager class
	pass
	#Networking.create_match(logging)

func _on_join_match_pressed() -> void:
	pass # Replace with function body.
	
func _on_go_to_network_menu_pressed() -> void:
	# load the networking menu UI module into the scene tree
	self.get_parent().add_child(networking_menu.instantiate())

	# remove the current session creation UI
	self.queue_free()
