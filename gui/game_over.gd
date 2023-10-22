extends Control

func _ready():
	pass

func _process(delta):
	$Panel/ScoreLabel.text = "Score: " + str(Map.score)

func _new_game():
	Map.set_to_menu()