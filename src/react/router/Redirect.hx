package react.router;

import haxe.extern.EitherType;
import history.Location;
import react.ReactComponent;

typedef RedirectProps = {
	/**
		The URL/Location to redirect to.

		When using `Location`, `pathname` can be any valid URL path that
		[`path-to-regexp`](https://www.npmjs.com/package/path-to-regexp)
		understands.
	*/
	var to:EitherType<String, Location>;

	/**
		When true, redirecting will push a new entry onto the history instead of
		replacing the current one.
	*/
	@:optional var push:Bool;

	/**
		A pathname to redirect from. Any valid URL path that
		[`path-to-regexp`](https://www.npmjs.com/package/path-to-regexp)
		understands.

		All matched URL parameters are provided to the pattern in `to`.
		Must contain all parameters that are used in `to`.
		Additional parameters not used by `to` are ignored.

		This can only be used to match a location when rendering a `<Redirect>`
		inside of a `<Switch>`.
	*/
	@:optional var from:String;

	/**
		When true, the active class/style will only be applied if the location
		is matched exactly.
	*/
	@:optional var exact:Bool;

	/**
		When true, the trailing slash on a location’s pathname will be taken
		into consideration when determining if the location matches the current
		URL.
		See the <Route strict> documentation for more information.
	*/
	@:optional var strict:Bool;
}

/**
	Rendering a <Redirect> will navigate to a new location. The new location
	will override the current location in the history stack, like server-side
	redirects (HTTP 3xx) do.

	See https://reacttraining.com/react-router/web/api/Redirect
*/
@:jsRequire('react-router', 'Redirect')
extern class Redirect extends ReactComponentOfProps<RedirectProps> {}

