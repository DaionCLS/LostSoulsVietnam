extends CharacterBody2D

@onready var AnimatedSprite2d = $AnimatedSprite2D
var speed = 300 

var MainSM: LimboHSM

var WeaponON = false


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if WeaponON == false:
			WeaponON = true
			MainSM.dispatch(&"to_AttackIdle")
		else:
			WeaponON = false
			MainSM.dispatch(&"to_Idle")
			
func _ready():
	initate_state_machine()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down") #var которая получает векторное значение (-x, +x, -y, +y)  в зависимости от нажатой кнопки ("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	print("Weapon", WeaponON)
	get_input()
	move_and_slide()

#функция создаёт новый State Machine
func initate_state_machine():
	MainSM = LimboHSM.new()
	add_child(MainSM)
	
	var Idle_State = LimboState.new().named("idle").call_on_enter(IdleStart).call_on_update(IdleUpdate)
	var Walk_State = LimboState.new().named("walk").call_on_enter(WalkStart).call_on_update(WalkUpdate)
	var AttackIdle_State = LimboState.new().named("attack_idle").call_on_enter(AttackIdleStart).call_on_update(AttackIdleUpdate)
	var AttackWalk_State = LimboState.new().named("attack_walk").call_on_enter(AttackWalkStart).call_on_update(AttackWalkUpdate)
	MainSM.add_child(Idle_State)
	MainSM.add_child(Walk_State)
	MainSM.add_child(AttackIdle_State)
	MainSM.add_child(AttackWalk_State)
	MainSM.initial_state = Idle_State
	
	MainSM.add_transition(MainSM.ANYSTATE, Walk_State, "to_Walk")
	MainSM.add_transition(MainSM.ANYSTATE, AttackIdle_State, "to_AttackIdle")
	MainSM.add_transition(MainSM.ANYSTATE, AttackWalk_State, "to_AttackWalk")
	MainSM.add_transition(MainSM.ANYSTATE, Idle_State, "to_Idle")
	
	MainSM.initialize(self)
	MainSM.set_active(true)

func IdleStart():
	print("IdleStart")
	AnimatedSprite2d.play("idle")
func IdleUpdate(delta: float):
	print("IdleUpdate")
	if velocity != Vector2.ZERO && !WeaponON:
		MainSM.dispatch(&"to_Walk")
	if velocity != Vector2.ZERO && WeaponON:
		MainSM.dispatch(&"to_AttackWalk")


func WalkStart():
	print("WalkStart")
	AnimatedSprite2d.play("walk")
func WalkUpdate(delta: float):
	print("WalkUpdate")
	if velocity == Vector2.ZERO && !WeaponON:
		MainSM.dispatch(&"to_Idle")
	if velocity == Vector2.ZERO && WeaponON:
		MainSM.dispatch(&"to_AttackIdle")


func AttackIdleStart():
	print("AttackIdleStart")
	AnimatedSprite2d.play("attack")
func AttackIdleUpdate(delta: float):
	print("AttackIdleUpdate")
	if velocity != Vector2.ZERO && !WeaponON:
		MainSM.dispatch(&"to_Walk")
	if velocity != Vector2.ZERO && WeaponON:
		MainSM.dispatch(&"to_AttackWalk")


func AttackWalkStart():
	print("AttackWalkStart")
	AnimatedSprite2d.play("attack")
func AttackWalkUpdate(delta: float):
	print("AttackWalkUpdate")
	if velocity == Vector2.ZERO && !WeaponON:
		MainSM.dispatch(&"to_Idle")
	if velocity == Vector2.ZERO && WeaponON:
		MainSM.dispatch(&"to_AttackIdle")
