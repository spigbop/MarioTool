class_name Mathx


static func clampi_cycle(value: int, min_val: int, max_val: int) -> int:
	if value < min_val:
		return max_val
	elif value > max_val:
		return min_val
	else:
		return value
