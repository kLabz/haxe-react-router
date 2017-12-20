package react.router;

@:enum abstract RouterAction(String) from String to String {
	var Push = "PUSH";
	var Replace = "REPLACE";
	var Pop = "POP";
}

