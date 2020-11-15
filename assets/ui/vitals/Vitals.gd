extends Control

var mana_count := Player.mana

onready var portrait_anim = $Portrait/AnimationPlayer
onready var mana_bars = [$ManaWhite,$ManaProgress]
onready var health_bars = [$HealthWhite,$HealthProgress]

func _ready():
	for mana in mana_bars:
		mana.max_value = Player.MAX_MANA
		mana.value = Player.mana
		mana.step = 0.01
	
	for health in health_bars:
		health.max_value = Player.MAX_HEALTH
		health.value = Player.health
		health.step = 0.01

func _process(delta):
	mana_bars[0].value = max(mana_bars[1].value,mana_bars[0].value - delta * 2)
	mana_bars[1].value = min(mana_count,mana_bars[1].value + delta * 3)
	
	health_bars[0].value = max(health_bars[1].value,health_bars[0].value - delta * 2)

func update_stealth(stealth):
	if stealth:
		portrait_anim.play("Transition")
	else:
		portrait_anim.play_backwards("Transition")

func update_mana(mana):
	mana_count = mana
	mana_bars[1].value = min(mana,mana_bars[1].value)

func update_health(health):
	health_bars[1].value = health
