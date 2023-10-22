extends Control

func _ready():
	pass

func _process(delta):
	$Score.text = "Score: " + str(Map.score)
	$HealthBar.margin_right = $HealthBar.margin_left + Map.player.health * 3.0
	$PowerBar.margin_right = $PowerBar.margin_left + Map.player.power * 3.0
	$PowerBar.color = Color(0x625646ff) if Map.player.exhausted else Color(0xef8b0cff)