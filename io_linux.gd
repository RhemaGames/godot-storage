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

func recursive_search(org:String,filetypes:Array,path:String,dict:Dictionary,schema:Dictionary):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin() 
		var file_name = dir.get_next()
		var starting_point = path.split("/")[-1]
		
		while file_name != "":
			if dir.current_is_dir():
				if !dict.has(file_name):
					dict[file_name] = { }
					recursive_search(org,filetypes,path+"/"+file_name,dict[file_name],schema)
			else:
				if file_name.split(".")[-1] in filetypes:
					if !dict[org].has(starting_point):
						dict[org][starting_point] = []
					var item = schema.duplicate()
					item["title"] = file_name.split(".")[0]
					item["url"] = path+"/"+file_name
					dict[org][starting_point].append(item)

			file_name = dir.get_next()
	else:
		print("Couldnt find path for", path)

	return 1
	
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
					bbc.append("[fontsize=20]"+line.split("#")[1].strip_edges()+"[/fontsize]\n")
				2:
					bbc.append("[b]"+line.split("##")[1].strip_edges()+"[/b]\n")
				2:
					bbc.append("[fontsize=16]"+line.split("###")[1].strip_edges()+"[/fontsize]\n")
		else:
			if line.length() > 0:
				bbc.append(line)
			else:
				bbc.append("\n")
			
	return bbc
