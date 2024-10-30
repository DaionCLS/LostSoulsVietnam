extends CharacterBody2D

var speed = 300 

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down") #var которая получает векторное значение (-x, +x, -y, +y)  в зависимости от нажатой кнопки ("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func huy():
	print_debug("suck suck")
