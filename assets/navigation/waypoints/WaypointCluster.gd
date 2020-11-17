extends Line2D

func rand_point() -> Vector2:
	if points.size() == 0:
		return Vector2.ZERO
	return points[randi() % points.size()]
