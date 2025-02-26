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


static func safe_convert(what: Variant, type: Variant.Type) -> Variant:
	if type == Variant.Type.TYPE_BOOL and typeof(what) == Variant.Type.TYPE_STRING:
		return what.to_lower().begins_with("t") or what == "1"
	else:
		if not type == TYPE_NIL:
			return convert(what, type)
		else:
			return null
