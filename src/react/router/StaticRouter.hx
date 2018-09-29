package react.router;

import haxe.extern.EitherType;
import history.Location;
import react.ReactComponent;

typedef StaticRouterProps = {
	/**
		The base URL for all locations. A properly formatted basename should
		have a leading slash, but no trailing slash.
	*/
	@:optional var basename:String;

	/**
		The URL the server received, probably req.url on a node server.
	*/
	@:optional var location:EitherType<String, Location>;

	/**
		During the render, components can add properties to the object to store
		information about the render.

		When a <Route> matches, it will pass the context object to the component
		it renders as the staticContext prop. Check out the Server Rendering
		guide for more information on how to do this yourself.

		After the render, these properties can be used to to configure the
		server’s response.
	*/
	var context:Dynamic;

	/**
		If using `react` < 16 or `react-router` < 4.4.0, a single child element
		to render.
	*/
	#if react_next
	var children:ReactFragment;
	#else
	var children:ReactElement;
	#end
}

/**
	A <Router> that never changes location.This can be useful in server-side
	rendering scenarios when the user isn’t actually clicking around, so the
	location never actually changes. Hence, the name: static. It’s also useful
	in simple tests when you just need to plug in a location and make assertions
	on the render output.

	See https://reacttraining.com/react-router/web/api/StaticRouter
*/
@:jsRequire('react-router', 'StaticRouter')
extern class StaticRouter extends ReactComponentOfProps<StaticRouterProps> {}

