extends Control

signal login_pressed(server_address: String, server_port: int, username: String, password: String)


func _ready():
	$Panel/VBoxContainer/ServerAddressText.text = Global.env_server_address
	$Panel/VBoxContainer/ServerPortText.text = str(Global.env_server_port)

	$Panel/VBoxContainer/LoginButton.pressed.connect(_on_login_button_pressed)
	$Panel/VBoxContainer/CreateAccountButton.pressed.connect(_on_create_account_button_pressed)


func show_error(message: String):
	$Panel/VBoxContainer/ErrorLabel.text = message

func _on_login_button_pressed():
	var server_address = $Panel/VBoxContainer/ServerAddressText.text
	var server_port = int($Panel/VBoxContainer/ServerPortText.text)

	if server_address == "" or server_port <= 0:
		$Panel/VBoxContainer/ErrorLabel.text = "Invalid server address or port"
		Logger.warn("Invalid server address or port")
		return

	var username = $Panel/VBoxContainer/UsernameText.text
	var password = $Panel/VBoxContainer/PasswordText.text

	if username == "" or password == "":
		$Panel/VBoxContainer/ErrorLabel.text = "Invalid username or password"
		Logger.warn("Invalid username or password")
		return

	login_pressed.emit(server_address, server_port, username, password)


func _on_create_account_button_pressed():
	print("Creating account")
