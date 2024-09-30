class_name Mathx


static func clampi_cycle(value: int, min_val: int, max_val: int) -> int:
	if value < min_val:
		return max_val
	elif value > max_val:
		return min_val
	else:
		return value


static func bool_gate(value: bool, val_tru = 1.0, val_false = 0.0) -> Variant:
	if value:
		return val_tru
	else:
		return val_false
