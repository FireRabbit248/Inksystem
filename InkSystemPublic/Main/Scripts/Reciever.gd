extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("paintSignal", self, "_paint")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _paint(paintPos : Vector3, radius : float, color : Color):
	print(paintPos)
	print(radius)
	print(color)

