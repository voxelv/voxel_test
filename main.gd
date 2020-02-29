extends Node

const Gen = preload("res://universe_gen.gd")

var terrain = VoxelTerrain.new()

onready var main_camera = find_node("main_camera")
onready var terrain_link = find_node("terrain_link")

func _ready():
	print(main_camera.get_path())
	terrain.stream = Gen.new()
	terrain.voxel_library = VoxelLibrary.new()
	terrain.view_distance = 192
	terrain.viewer_path = main_camera.get_path()
	terrain_link.add_child(terrain)
