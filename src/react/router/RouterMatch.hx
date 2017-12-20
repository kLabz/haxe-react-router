package react.router;

/**
	A match object contains information about how a <Route path> matched the
	URL.

	See https://reacttraining.com/react-router/web/api/match
*/
typedef RouterMatch = {
	/**
		Key/value pairs parsed from the URL corresponding to the dynamic
		segments of the path.
	*/
	var params:Dynamic<String>;

	/**
		`true` if the entire URL was matched (no trailing characters).
	*/
	var isExact:Bool;

	/**
		The path pattern used to match. Useful for building nested <Route>s.
	*/
	var path:String;

	/**
		The matched portion of the URL. Useful for building nested <Link>s.
	*/
	var url:String;
}

