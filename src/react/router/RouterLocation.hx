package react.router;

/**
	Locations represent where the app is now, where you want it to go, or even
	where it was.

	See https://reacttraining.com/react-router/web/api/location
*/
typedef RouterLocation = {
	var pathname:String;
	var search:String;
	var hash:String;
	var state:Dynamic;
}
