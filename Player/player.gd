extends KinematicBody2D

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var direction = RIGHT
var action_queue = []
var prev_act

const MAX_SPEED = 400

var vel = Vector2()

var target_pos = Vector2()
var target_direction = Vector2()
var new_direction = true

var grid
var type

func _ready():
	grid = get_parent()
	type = grid.PLAYER
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var aq_size = action_queue.size()
	if aq_size != 0:
		prev_act = action_queue[-1]
	else:
		prev_act = target_direction

	if event.is_action_pressed("move_up"):
		if aq_size <2 and prev_act != DOWN and prev_act != UP:
			action_queue.push_back(UP)
	if event.is_action_pressed("move_down"):
		if aq_size <2 and prev_act != UP and prev_act != DOWN:
			action_queue.push_back(DOWN)
	if event.is_action_pressed("move_right"):
		if aq_size <2 and prev_act != LEFT and prev_act != RIGHT:
			action_queue.push_back(RIGHT)
	if event.is_action_pressed("move_left"):
		if aq_size <2 and prev_act != RIGHT and prev_act != LEFT:
			action_queue.push_back(LEFT)
#	print(action_queue)

func _fixed_process(delta):
	if new_direction:
		if action_queue.size() >=1:
			direction = action_queue[0]
			action_queue.pop_front()
		if grid.is_cell_vacant(get_pos(), direction):
			target_pos = grid.update_child_pos(get_pos(), direction, type)
			vel = direction * MAX_SPEED * delta
			target_direction = direction
			new_direction = false
		else:
			return

	var pos = get_pos()
	var distance_to_target = pos.distance_to(target_pos)
	var move_distance = vel.length()

	if move_distance > distance_to_target:
		vel = distance_to_target * target_direction
		print(move_distance)
		new_direction = true
	move(vel)