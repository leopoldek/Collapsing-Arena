extends Control

func _ready():
	Map.connect("new_stage", self, "_new_stage")

func _new_stage():
	match Map.stage:
		Map.STAGE_MENU:
			$Menu.visible = true
			$InGame.visible = false
			$GameOver.visible = false
		Map.STAGE_GAME:
			$Menu.visible = false
			$InGame.visible = true
			$GameOver.visible = false
		Map.STAGE_OVER:
			$Menu.visible = false
			$InGame.visible = false
			$GameOver.visible = true