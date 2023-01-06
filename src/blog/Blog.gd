extends Control

onready var networking = $Networking

onready var loading_cont = $Panel/LoadingCont
onready var error_cont = $Panel/ErrorCont
onready var error_label = $Panel/ErrorCont/VBoxContainer/ErrorLabel
onready var main_cont = $Panel/MainCont
onready var blog_text = $Panel/MainCont/BlogText

func make_http_req(id: String, url: String, headers: Array, secure, method, req_body: Dictionary):
	var http_req_node: HTTPRequest = HTTPRequest.new()
	http_req_node.use_threads = true
	networking.add_child(http_req_node)
	http_req_node.connect("request_completed", self, "http_req_handler", [http_req_node, id])
	http_req_node.request(
		url, 
		headers, 
		secure, 
		method, 
		to_json(req_body)
	)

func do_error(error: String):
	error_label.text = error
	error_cont.visible = true

func _ready():
	loading_cont.visible = true
	error_cont.visible = false
	main_cont.visible = false
	blog_text.bbcode_text = ""
	make_http_req(
		"get_blog",
		"https://osakitsukiko.github.io/godot-journey/blog.json",
		[],
		true,
		HTTPClient.METHOD_GET,
		{}
	)

func http_req_handler(result, response_code, headers, body, req_node, id):
	req_node.queue_free()
	if (id == "get_blog"):
		loading_cont.visible = false
		if (response_code == 200):
			var json: Array = parse_json(body.get_string_from_utf8())
			for article in json:
				blog_text.bbcode_text += ("\n[center][b][color=#" + article["color"] + "]" + article["title"] + "[/color][/b][/center]\n\n")
				for segment in article["segments"]:
					if (segment["type"] == "TEXT"):
						blog_text.bbcode_text += ("[i][color=#" + segment["color"] + "]" + segment["title"] + "[/color][/i]\n")
						var text: String = segment["text"]
						text = text.replace("[code]", "[color=#ace66a][code]")
						text = text.replace("[/code]", "[/code][/color]")
						blog_text.bbcode_text += (text + "\n\n")
					if (segment["type"] == "CODE"):
						blog_text.bbcode_text += ("[color=#ace66a][code]" + segment["text"] + "[/code][/color]\n\n")
			main_cont.visible = true
		elif (response_code == 404):
			do_error("Wrong URL! E404")
		elif (response_code == 0):
			do_error("No Internet! E0")
		else:
			do_error("Error! Code: " + String(response_code))
