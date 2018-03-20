package react.router;

import history.Location;

/**
	Locations represent where the app is now, where you want it to go, or even
	where it was.

	See https://reacttraining.com/react-router/web/api/location
*/
@:deprecated('RouterLocation is deprecated, use history.Location instead')
typedef RouterLocation = {
	> Location,
}
