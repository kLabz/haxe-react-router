package react.router;

import haxe.extern.EitherType;
import react.ReactComponent;

typedef RedirectProps = {
	/**
		The URL/Location to redirect to.
	*/
	var to:EitherType<String, RouterLocation>;

	/**
		When true, redirecting will push a new entry onto the history instead of
		replacing the current one.
	*/
	@:optional var push:Bool;

	/**
		A pathname to redirect from. This can only be used to match a location
		when rendering a <Redirect> inside of a <Switch>.
	*/
	@:optional var from:String;
}

/**
	Rendering a <Redirect> will navigate to a new location. The new location
	will override the current location in the history stack, like server-side
	redirects (HTTP 3xx) do.

	See https://reacttraining.com/react-router/web/api/Redirect
*/
@:jsRequire('react-router', 'Redirect')
extern class Redirect extends ReactComponentOfProps<RedirectProps> {}

