extends Node2D
class_name CameraController2D

@export var min_zoom = 0.05
@export var max_zoom = 1.0
@export var zoom_step = 0.01

var camera: Camera2D

@export var movement_speed = 64.0

func _ready():
	for child in get_children():
		if child is Camera2D:
			camera = child

func _process(delta):
	if Input.is_action_just_pressed("zoom_in"):
		camera.zoom = clamp(camera.zoom + Vector2.ONE*zoom_step, Vector2.ONE*min_zoom, Vector2.ONE*max_zoom)
	if Input.is_action_just_pressed("zoom_out"):
		camera.zoom = clamp(camera.zoom - Vector2.ONE*zoom_step, Vector2.ONE*min_zoom, Vector2.ONE*max_zoom)
		
	
	var movement_vector = Input.get_vector("left", "right", "up", "down")
	position += movement_vector * movement_speed * delta
