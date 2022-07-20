extends Spatial

var children = []


# Called when the node enters the scene tree for the first time.
func _ready():
	children = get_children()



# Draw method is used to place color,
# calls the draw method from the child nodes for this purpose
#
# @param paintPos : Position of the brush
# @param radius : Radius of the brush
# @param color : Color of the brush
func _paint(paintPos: Vector3, radius : float, color : Color):
	for child in children:
		if child.has_method("_get_paint"):
			child._get_paint(paintPos, radius, color)
		
		if child is Spatial and child.get_child(0).has_method("_get_paint"):
			child.get_child(0)._get_paint(paintPos, radius, color)

