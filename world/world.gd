extends Node

const Songs = [
	preload("res://music/Heroic Intrusion.ogg"),
	preload("res://music/Interstellar Odyssey.ogg"),
	preload("res://music/251461__joshuaempyre__arcade-music-loop.wav")
]

const BasicEnemy = preload("res://enemies/basic/basic_enemy.tscn")
const SwiperEnemy = preload("res://enemies/swiper/swiper_enemy.tscn")
const MonsterEnemy = preload("res://enemies/monster/monster_enemy.tscn")

func _ready():
	Map.connect("new_stage", self, "_new_stage")

func _process(delta):
	var point = Map.random_point()
	if Map.is_inside(point) and not Map.near_player(point, 250.0):
		var r = randf()
		if r > 0.95:
			var enemy = MonsterEnemy.instance()
			enemy.position = point
			$Enemies.add_child(enemy)
		elif r > 0.9:
			var enemy = SwiperEnemy.instance()
			enemy.position = point
			$Enemies.add_child(enemy)
		elif r > 0.7:
			var enemy = BasicEnemy.instance()
			enemy.position = point
			$Enemies.add_child(enemy)

func _new_stage():
	if Map.stage == Map.STAGE_MENU:
		get_tree().reload_current_scene()
	if Map.stage == Map.STAGE_GAME:
		$MusicPlayer.stream = Songs[randi() % 3]
		$MusicPlayer.play()
	if Map.stage == Map.STAGE_OVER:
		$MusicPlayer.stop()