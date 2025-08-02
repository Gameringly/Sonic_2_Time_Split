extends Node2D

@export var music = preload("res://Audio/Soundtrack/6. SWD_TLZa1.ogg")
@export var nextZone = load("res://Scene/Zones/BaseZone.tscn")

#@export_enum("Present", "Past", "Bad Future", "Good Future") var Timezone = 0

@export_enum("Bird", "Squirrel", "Rabbit", "Chicken", "Penguin", "Seal", "Pig", "Eagle", "Mouse", "Monkey", "Turtle", "Bear")var animal1 = 0
@export_enum("Bird", "Squirrel", "Rabbit", "Chicken", "Penguin", "Seal", "Pig", "Eagle", "Mouse", "Monkey", "Turtle", "Bear")var animal2 = 1

# Boundries
@export var setDefaultLeft = true
@export var defaultLeftBoundry  = -100000000
@export var setDefaultTop = true
@export var defaultTopBoundry  = -100000000

@export var setDefaultRight = true
@export var defaultRightBoundry = 100000000
@export var setDefaultBottom = true
@export var defaultBottomBoundry = 100000000

@onready var Present = $Present
@onready var Past = $Past
@onready var GFuture = $GoodFuture
@onready var BFuture = $BadFuture

@onready var hud = $HUD

# was loaded is used for room loading, this can prevent overwriting global information, see Global.gd for more information on scene loading
var wasLoaded = false

var gotTimeStone = false

func _ready():
	# debuging
	if !Global.is_main_loaded:
		return false
	# skip if scene was loaded
	if wasLoaded:
		return false
	
	if setDefaultLeft:
		Global.hardBorderLeft  = defaultLeftBoundry
	if setDefaultRight:
		Global.hardBorderRight = defaultRightBoundry
	if setDefaultTop:
		Global.hardBorderTop    = defaultTopBoundry
	if setDefaultBottom:
		Global.hardBorderBottom  = defaultBottomBoundry
	
	level_reset_data(false)
	
	remove_child(Past)
	remove_child(GFuture)
	remove_child(BFuture)
	
	wasLoaded = true

# used for stage starts, also used for returning from special stages
func level_reset_data(playCard = true):
	# music handling
	if Global.music != null:
		if music != null:
			Global.music.stream = music
			Global.music.play()
			Global.music.stream_paused = false
		else:
			Global.music.stop()
			Global.music.stream = null
	# set next zone
	if nextZone != null:
		Global.nextZone = nextZone
	
	# set pausing to true
	if Global.main != null:
		Global.main.sceneCanPause = true
	# set animals
	Global.animals = [animal1,animal2]
	# if global hud and play card, run hud ready script
	if playCard and is_instance_valid(Global.hud):
		$HUD._ready()

func TimeTravel(TimePeriod):
	Global.main.fader.play("TimeWarp")
	await Global.main.fader.animation_finished
	if TimePeriod == "Past" and has_node("Present"):
		remove_child(Present)
		add_child(Past)
		hud.lifeIcon.frame = 5
	elif TimePeriod == "Past" and has_node("BadFuture"):
		remove_child(BFuture)
		add_child(Present)
		hud.lifeIcon.frame = Global.PlayerChar1-1
	elif TimePeriod == "Past" and has_node("GoodFuture"):
		remove_child(GFuture)
		add_child(Present)
		hud.lifeIcon.frame = Global.PlayerChar1-1
	elif TimePeriod == "Future" and has_node("Past"):
		remove_child(Past)
		add_child(Present)
		hud.lifeIcon.frame = Global.PlayerChar1-1
	elif TimePeriod == "Future" and has_node("Present") and !gotTimeStone:
		remove_child(Present)
		add_child(BFuture)
		hud.lifeIcon.frame = 6
	elif TimePeriod == "Future" and has_node("Present") and gotTimeStone:
		remove_child(Present)
		add_child(GFuture)
		hud.lifeIcon.frame = 6
	Global.main.fader.play_backwards("TimeWarp")
	$Player.lock_camera(0.5)
	$Player.visible = true
	var part = $Player.Particle.instantiate()
	part.global_position = $Player.global_position
	part.z_index = 10
	part.rotation = $Player.timeWarpAura.rotation
	part.play("TimeDust")
	add_child(part)
