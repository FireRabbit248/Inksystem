tool
extends Spatial

export (Vector2) var textureSize
export (String) var imageName = "texture.png"
onready var o_sampleViewport = $SampleViewport
onready var o_expandIslandViewport = $ExpandIslandViewPort
onready var o_sampleMesh = $SampleViewport/SampleMesh

var countdown = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	o_sampleViewport.size = textureSize
	o_expandIslandViewport.size = textureSize
	$TextureRect.rect_position = textureSize
	
	var newSize = 1.0 / o_sampleMesh.get_aabb().get_longest_axis_size()
	scale = Vector3(newSize, newSize, newSize)

func _process(delta):
	if countdown > 0:
		countdown -= 1
	if countdown == 0:
		# Save Image 
		if o_expandIslandViewport:
			var img = o_expandIslandViewport.get_texture().get_data()
			img.save_png(imageName)
	
