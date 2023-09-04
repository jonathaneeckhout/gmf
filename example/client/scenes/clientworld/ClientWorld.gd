extends Node2D

enum STATES { INIT, LOGIN_SCREEN, CONNECT, DISCONNECTED, AUTHENTICATE, RUNNING }

var state: STATES = STATES.INIT
var fsm_timer: Timer

var login_pressed: bool = false
var address: String
var port: int
var user: String
var passwd: String

@onready var login_panel = $LoginPanel


func _ready():
	# Add a short timer to deffer the fsm() calls
	fsm_timer = Timer.new()
	fsm_timer.wait_time = 0.1
	fsm_timer.autostart = false
	fsm_timer.one_shot = true
	fsm_timer.timeout.connect(_on_fsm_timer_timeout)
	add_child(fsm_timer)

	login_panel.login_pressed.connect(_on_login_pressed)


func fsm():
	match state:
		STATES.INIT:
			_handle_init()
		STATES.LOGIN_SCREEN:
			_handle_login_screen()
		STATES.CONNECT:
			pass
			_handle_connect()
		STATES.DISCONNECTED:
			pass
		STATES.AUTHENTICATE:
			pass
			# _handle_authenticate()
		STATES.RUNNING:
			pass


func _handle_init():
	state = STATES.LOGIN_SCREEN
	fsm_timer.start()


func _handle_login_screen():
	$LoginPanel.show()

	if login_pressed:
		login_pressed = false
		state = STATES.CONNECT

		fsm_timer.start()


func _handle_connect():
	if !Global.client.connect_to_server(address, port):
		Logger.warn("Could not connect to server=[%s] on port=[%d]" % [address, port])
		login_panel.show_error("Error conneting server")
		state = STATES.INIT
		fsm_timer.start()
		return

	if !await Signals.client_connected:
		Logger.warn("Could not connect to server=[%s] on port=[%d]" % [address, port])
		login_panel.show_error("Error conneting server")
		state = STATES.INIT
		fsm_timer.start()
		return

	Logger.info("Connected to server=[%s] on port=[%d]" % [address, port])

	state = STATES.AUTHENTICATE
	fsm_timer.start()


func _on_fsm_timer_timeout():
	fsm()


func _on_login_pressed(
	server_address: String, server_port: int, username: String, password: String
):
	login_pressed = true
	address = server_address
	port = server_port
	user = username
	passwd = password

	fsm()
