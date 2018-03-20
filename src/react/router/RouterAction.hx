package react.router;

@:deprecated('RouterAction is deprecated, use history.Action instead')
@:enum abstract RouterAction(String) from String to String {
	var Push = "PUSH";
	var Replace = "REPLACE";
	var Pop = "POP";
}

