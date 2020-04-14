extends Spatial

const near_vertex_preload = preload("res://near_vertex/near_vertex.tscn")

# Near Vertices Settings
export(float) var near_vertex_radius = 7.0
export(int) var vox_per_vertex = 2

func _ready():
	spawn_near_vertices()
	pass

func spawn_near_vertices():
	for i in range(int(near_vertex_radius * 2)):
		var x = i - int(near_vertex_radius)
		for j in range(int(near_vertex_radius * 2)):
			var y = j - int(near_vertex_radius)
			for k in range(int(near_vertex_radius * 2)):
				var z = k - int(near_vertex_radius)
				var pos = Vector3(x*vox_per_vertex, y*vox_per_vertex, z*vox_per_vertex)
				if(pos.length() < near_vertex_radius):
					var new_near_vertex = near_vertex_preload.instance()
					add_child(new_near_vertex)
					new_near_vertex.setup(near_vertex_radius, vox_per_vertex)
					new_near_vertex.transform.origin = pos
