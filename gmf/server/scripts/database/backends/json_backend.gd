extends Node

const USERS_FILEPATH = "data/users.json"


func init() -> bool:
	return create_file_if_not_exists(USERS_FILEPATH, {})


func create_file_if_not_exists(path: String, json_data: Dictionary) -> bool:
	if FileAccess.file_exists(path):
		Gmf.logger.debug("File=[%s] already exists" % path)
		return true

	return write_json_to_file(path, json_data)


func write_json_to_file(path: String, json_data: Dictionary) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		Gmf.logger.err("Could not open file=[%s] to write" % path)
		return false

	var string_data = JSON.stringify(json_data, "    ")

	file.store_string(string_data)

	file.close()

	return true


func create_account(username: String, password: String) -> bool:
	var file = FileAccess.open(USERS_FILEPATH, FileAccess.READ)
	if file == null:
		Gmf.logger.warn("Could not open file=[%s] to read" % USERS_FILEPATH)
		return false

	var users_string = file.get_as_text()

	var users_json = JSON.parse_string(users_string)
	if users_json == null:
		Gmf.logger.warn("Could not json parse content of %s" % USERS_FILEPATH)
		return false

	if username in users_json:
		Gmf.logger.info("User=[%s] already exists" % username)
		return false

	users_json[username] = password

	if not write_json_to_file(USERS_FILEPATH, users_json):
		Gmf.logger.warn("Could not store new user")
		return false

	Gmf.logger.info("Successfully created user=[%s]" % username)

	return true
