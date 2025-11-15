extends CanvasLayer

var car_speed : float = 0
@onready var car = $".."


func _physics_process(delta: float) -> void:
	car_speed = car.linear_velocity.length()
	$Speedometer/speedometer.value = lerp($Speedometer/speedometer.value, car_speed + 12, 5 * delta)
	$Speedometer/speed.text = str(snapped(car_speed * 1.5, 1))
	
	car.can_park = true if car_speed < 12 else false
	if car.can_park:
		$Speedometer/ParkIcon.add_theme_color_override("font_color", Color(1, 1, 1))
	else:
		$Speedometer/ParkIcon.add_theme_color_override("font_color", Color(1, 0, 0))
	
	match car.current_gear:
		car.Gears.DRIVE:
			$Speedometer/Tick.position.y = lerp($Speedometer/Tick.position.y, 67.0, 8 * delta)
		car.Gears.NEUTRAL:
			$Speedometer/Tick.position.y = lerp($Speedometer/Tick.position.y, 90.5, 8 * delta)
		car.Gears.REVERSE:
			$Speedometer/Tick.position.y = lerp($Speedometer/Tick.position.y, 114.0, 8 * delta)
		car.Gears.BREAK:
			$Speedometer/Tick.position.y = lerp($Speedometer/Tick.position.y, 137.0, 8 * delta)
