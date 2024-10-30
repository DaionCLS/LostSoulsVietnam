extends CharacterBody2D

@onready var AnimatedSprite2d = $AnimatedSprite2D
var speed = 300 

var MainSM: LimboHSM

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		MainSM.dispatch(&"to_Attack")


func _ready():
	initate_state_machine()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down") #var которая получает векторное значение (-x, +x, -y, +y)  в зависимости от нажатой кнопки ("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

#функция создаёт новый State Machine
func initate_state_machine():
	MainSM = LimboHSM.new()
	add_child(MainSM)
	
	var Idle_State = LimboState.new().named("idle").call_on_enter(IdleStart).call_on_update(IdleUpdate)
	var Walk_State = LimboState.new().named("walk").call_on_enter(WalkStart).call_on_update(WalkUpdate)
	var Attack_State = LimboState.new().named("attack").call_on_enter(AttackStart).call_on_update(AttackUpdate)
	
	MainSM.add_child(Idle_State)
	MainSM.add_child(Walk_State)
	MainSM.add_child(Attack_State)
	
	MainSM.initial_state = Idle_State
	
	MainSM.add_transition(MainSM.ANYSTATE, Walk_State, "to_Walk")
	MainSM.add_transition(MainSM.ANYSTATE, Attack_State, "to_Attack")
	MainSM.add_transition(MainSM.ANYSTATE, Idle_State, "State_Ended")
	
	MainSM.initialize(self)
	MainSM.set_active(true)

func IdleStart():
	print("IdleStart")
func IdleUpdate(delta: float):
	print("IdleUpdate")
	if velocity.x or velocity.y != 0:
		MainSM.dispatch(&"to_Walk")
	
func WalkStart():
	print("WalkStart")
func WalkUpdate(delta: float):
	print("WalkUpdate")
	if velocity == Vector2.ZERO:
		MainSM.dispatch(&"State_Ended")
func AttackStart():
	print("AttackStart")
func AttackUpdate(delta: float):
	print("AttackUpdate")
	if velocity.x or velocity.y != 0:
		MainSM.dispatch(&"to_Walk")
