extends Node

# Use this game API key if you want to test with a functioning leaderboard
# "987dbd0b9e5eb3749072acc47a210996eea9feb0"
var game_API_key = "dev_7c33b0dd7a8148069ede5f47dbbf81ec"
var development_mode = true
var leaderboard_key = "ScoreSpaceJam"
var session_token = ""
var score := .0
var player_name = "Paul"
var player_identifier = ""

@onready var leaderboard = VBoxContainer.new()

func convert_time(time_in_seconds: float) -> String:
	var minutes = int(time_in_seconds / 60)
	var seconds = int(time_in_seconds) % 60
	var milliseconds = int((time_in_seconds - int(time_in_seconds)) * 1000)
	
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(3)


func _create_entry(name: String, score: float):
	var one_entry = HBoxContainer.new()
	one_entry.alignment = BoxContainer.ALIGNMENT_CENTER
	var name_label = Label.new()
	var score_label = Label.new()
	
	one_entry.add_child(name_label )
	one_entry.add_child(score_label)
	
	name_label.text = name + " - "
	score_label.text = convert_time(score/1000)
	
	leaderboard.add_child(one_entry)

# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

func _ready():
	_authentication_request()
	pass

func _authentication_request():
	# Check if a player session exists
	var player_session_exists = false
	var file = FileAccess.open("user://LootLocker.data", FileAccess.READ)
	if file != null:
		player_identifier = file.get_as_text()
		file.close()
 
	if player_identifier != null and player_identifier.length() > 1:
		player_session_exists = true
	if(player_identifier.length() > 1):
		player_session_exists = true
		
	## Convert data to json string:
	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }
	
	# If a player session already exists, send with the player identifier
	if(player_session_exists == true):
		data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": true }
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	# Send request
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	var res = await auth_http.request_completed
	_on_authentication_request_completed(res[3])
	# Print what we're sending, for debugging purposes:


func _on_authentication_request_completed(body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Save the player_identifier to file
	var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
	file.store_string(json.get_data().player_identifier)
	file.close()
	
	# Save session_token to memory
	session_token = json.get_data().session_token
	
	# Print server response
	
	# Clear node
	auth_http.queue_free()


func get_leaderboards():
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")
	var a = await leaderboard_http.request_completed
	_on_leaderboard_request_completed(a[3])
	 
	return leaderboard
	#leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	# Send request

func _on_leaderboard_request_completed( body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Formatting as a leaderboard
	var leaderboardFormatted = ""
	
	leaderboard = VBoxContainer.new()
		
	for n in json.get_data().items.size():
		_create_entry(json.get_data().items[n].metadata, json.get_data().items[n].score)
	
	# Clear node
	leaderboard_http.queue_free()


func _upload_score():
	var data = { "score": str(score), "metadata": player_name if player_name != "" else player_identifier }
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:


func _on_upload_score_request_completed(result, response_code, headers, body) :
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	
	# Clear node
	submit_score_http.queue_free()
