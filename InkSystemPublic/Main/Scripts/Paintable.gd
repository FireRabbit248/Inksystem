extends Spatial



# Paintable Node
# needs a MeshInstance with the name "InkSurface" and a KinematicBody or Rigidbody as a child
#
# The texture of the PaintMask stores which point on the surface is at which 3D position. 
# The viewport contains the PaintMask, this can be used by others as a mask in a fragment shader.
onready var o_inkSurface := $InkSurface
onready var o_paintMask := $Viewport/PaintMask
onready var o_viewport := $Viewport

var mat : Material
var meshScale : Vector3
var meshPosition : Vector3
var meshRotation : Vector3
var isKinematicBody : bool
var meshOriginalSize : float



# Called when the node enters the scene tree for the first time.
func _ready():
	mat = o_paintMask.material
	if o_inkSurface:
		meshScale = o_inkSurface.global_transform.basis.get_scale()
		meshPosition = o_inkSurface.global_transform.origin
		meshRotation = o_inkSurface.global_transform.basis.get_euler()
		isKinematicBody = o_inkSurface.get_child(0) is KinematicBody
	else:
		print("Meshinstance with name \"InkSurface\" is missing")
	SignalBus.connect("paintSignal", self, "_paint")
	
	o_viewport.get_texture().flags = Texture.FLAG_FILTER
	
	# set ViewportSize to fit the TextureRect
	if o_paintMask.texture:
		o_viewport.size = o_paintMask.texture.get_size()
	else:
		print("PaintMask needs a texture")
	
	meshOriginalSize = o_inkSurface.get_aabb().get_longest_axis_size()


func _physics_process(_delta):
	# Update position and rotation of KinematicBodies
	if isKinematicBody: 
		meshPosition = o_inkSurface.global_transform.origin
		meshRotation = o_inkSurface.global_transform.basis.get_euler()



func _paint(paintPos : Vector3, radius : float, color : Color):
	print(meshOriginalSize)
	if paintPos:
		# Translation
		paintPos -= meshPosition
		# Scale
		paintPos /= meshScale * meshOriginalSize
		# Rotation around the y-Axis
		paintPos = paintPos.rotated(o_inkSurface.global_transform.basis.y.normalized(), -meshRotation.y)
		
		mat.set_shader_param("pos", paintPos)
		mat.set_shader_param("brushColor", color)
		mat.set_shader_param("radius", radius / meshScale.x / meshOriginalSize)
		o_viewport.render_target_update_mode = Viewport.UPDATE_ONCE
