extends VoxelStream
class_name UniverseGen

export var channel:int = VoxelBuffer.CHANNEL_TYPE

func get_used_channels_mask () -> int:
		return 1<<channel
 
func emerge_block(buffer:VoxelBuffer, origin:Vector3, lod:int) -> void:
#	if lod != 0: return
#	if origin.y < 0:
#		buffer.fill(1, channel)
#	else:
	for x in range(buffer.get_size_x()):
		for y in range(buffer.get_size_y()):
			for z in range(buffer.get_size_z()):
				if x % 4 == 0 and y % 4 == 0 and z % 4 == 0:
					buffer.set_voxel(1, x, y, z, channel)

func _ready():
	pass
