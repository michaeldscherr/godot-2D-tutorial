extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$Player.start($StartPosition.position)
	
	get_tree().call_group("mobs", "queue_free")
	
	$StartTimer.start()
	
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	# create a new instance
	var mob = mob_scene.instantiate()
	
	# choose a random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	
	mob_spawn_location.progress_ratio = randf()
	
	# set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	
	# choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

