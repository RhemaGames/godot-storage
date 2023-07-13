extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recursive_search(org:String,filetypes:Array,ignore:Array,path:String,dict:Dictionary,schema:Dictionary):
	var dir = DirAccess.open(path)
	var returning:Array = []
	if dir:
		dir.list_dir_begin() 
		var file_name = dir.get_next()
		var starting_point = path.split("/")[-1]
		while file_name != "":
			if dir.current_is_dir():
				if !file_name in ignore:
					if !dict[org].has(starting_point):
						dict[org][starting_point] = {}
					if !dict[org][starting_point].has(file_name):
						dict[org][starting_point][file_name] = { }
					var meh = recursive_search(org+"/"+starting_point,filetypes,ignore,path+"/"+file_name,dict[org][starting_point][file_name],schema)
					print_debug(meh)
			else:
				var extension = ""
				if file_name.split(".").size() > 2:
					extension = file_name.split(".")[-2]+"."+file_name.split(".")[-1]
				else:
					extension = file_name.split(".")[-1]
				if extension in filetypes:
					print_debug("Found filename: ",file_name)
					var item = schema.duplicate()
					item["title"] = file_name.split(".")[0]
					item["url"] = path+"/"+file_name
					returning.append(item)
					dict.merge(item)

			file_name = dir.get_next()
	else:
		print("Couldnt find path for", path)
	return returning
	
func read_file(url:String,inputType:String):
	var text:Array = []
	var file = FileAccess.open(url, FileAccess.READ)
	if file:
		if inputType == "md":
			text = md_2_bbc(file.get_as_text())
	return text

func md_2_bbc(text:String):
	var bbc:Array = []
	var lines = text.split("\n")
	#print(lines.size())
	for line in lines:
		var start = line.left(3)
		if start.count("#") > 0:
			match start.count("#"):
				1:
					bbc.append("[font_size=34][b]"+line.split("#")[1].strip_edges()+"[/b][/font_size]\n")
				2:
					bbc.append("[b]"+line.split("##")[1].strip_edges()+"[/b]\n")
				3:
					bbc.append("[font_size=16]"+line.split("###")[1].strip_edges()+"[/font_size]\n")
		elif start.left(1) == "-":
			bbc.append("[ul]"+line.substr(1,-1)+"[/ul]")
		elif start.left(2) == " -":
			bbc.append(" "+line.substr(2,-1)+"\n")
		else:
			if line.length() > 0:
				bbc.append(line)
			else:
				bbc.append("\n")
		
		#bbc.append("\n")
		
			
	return bbc
