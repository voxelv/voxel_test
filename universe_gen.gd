extends VoxelStream
class_name UniverseGen

const opts = [1, 4, 8, 16]
const opts_cnt = len(opts)

export var channel:int = VoxelBuffer.CHANNEL_TYPE

func get_used_channels_mask () -> int:
		return 1<<channel
 
func emerge_block(buffer:VoxelBuffer, origin:Vector3, lod:int) -> void:
	var num := int(opts[randi() % opts_cnt])
#	var num = 4
#	if lod != 0: return
#	if origin.y < 0:
#		buffer.fill(1, channel)
#	else:
#	if Vector3.ZERO.distance_squared_to(origin) > (350*350):
#		buffer.fill(1, channel)
#	if randi() % 4 == 0:
	for x in range(buffer.get_size_x()):
		for y in range(buffer.get_size_y()):
			for z in range(buffer.get_size_z()):
#				if x % 4 == 0 and y % 4 == 0 and z % 4 == 0:
				if x % num == 0 and y % num == 0 and z % num == 0:
#				if (x + y + z) % 2 == 0:
					buffer.set_voxel(1, x, y, z, channel)

func _ready():
	pass
