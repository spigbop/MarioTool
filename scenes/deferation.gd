class_name Deferation


static func execute_on(node: Node, object_deferation: PackedStringArray) -> Variant:
	for line in object_deferation:
		line = line.replace(" ", "")
		
		if "=" in line:
			var data = line.split("=")
			if data[0] in node:
				node.set_deferred(data[0], Mathx.safe_convert(data[1], typeof(node.get(data[0]))))
				return line
			else:
				return "<no_prop>"
		
		elif "(" in line and ")" in line:
			var data = line.left(-1).split("(")
			if node.has_method(data[0]):
				var arglist: Array = data[1].split(",")
				var types = get_method_argtype(node, data[0])
				var argi = 0
				for arg in arglist:
					if arg.begins_with('"') and arg.ends_with('"'):
						arglist[argi] = arg.left(-1).right(-1)
					if types.size() > argi and types[argi]:
						arglist[argi] = Mathx.safe_convert(arglist[argi], types[argi])
					argi += 1
				return node.callv(data[0], Mathx.bool_gate(data[1] == "", [], arglist))
			else:
				return "<no_method>"
		
		elif line in node:
			return node.get(line)
	
	return 0

static func get_method_argtype(node: Node, method_name : String) -> Array:
	for method in node.get_script().get_script_method_list():
		if method.name == method_name:
			var argument_types : Array = [];
			for arg in method.args:
				argument_types.push_back(arg.type);
			return argument_types;
	
	return [];
