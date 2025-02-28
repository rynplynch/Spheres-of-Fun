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

#TODO: write UI update logic
func update_matches() -> void:
	# get existing matches from Nakama, returns as a list?
	pass
	
	# Update UI with the list..
	
	# return

#TODO: tell nakama to create a match
func _on_create_match_pressed() -> void:
	# Call match_manager class
	pass # Replace with function body.

func _on_join_match_pressed() -> void:
	pass # Replace with function body.
	
func _on_go_to_network_menu_pressed() -> void:
	# load the networking menu UI module into the scene tree
	self.get_parent().add_child(networking_menu.instantiate())

	# remove the current session creation UI
	self.queue_free()
