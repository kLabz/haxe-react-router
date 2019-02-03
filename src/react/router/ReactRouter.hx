package react.router;

import haxe.extern.EitherType;
import history.Location;
import react.router.Route.RouteMatchProps;

#if (!react_next && (react < "2.0"))
private typedef ReactType = react.React.CreateElementType;
#else
import react.ReactType;
#end

@:jsRequire('react-router')
extern class ReactRouter {
	/**
		This lets you use the same matching code that <Route> uses except
		outside of the normal render cycle, like gathering up data dependencies
		before rendering on the server.

		See https://reacttraining.com/react-router/web/api/matchPath
	*/
	public static function matchPath(pathname:String, props:RouteMatchProps):Null<RouterMatch>;

	/**
		You can get access to the history object’s properties and the closest
		<Route>'s match via the withRouter higher-order component. withRouter
		will re-render its component every time the route changes with the same
		props as <Route> render props: { match, location, history }.

		See https://reacttraining.com/react-router/web/api/withRouter
	*/
	public static function withRouter(component:ReactType):ReactType;

	/**
		Generate a URL pathname from a pattern and parameters.

		Added in react-router 4.3.0
		https://github.com/ReactTraining/react-router/pull/5209/files#diff-eda9009f7d0179544cd0474e7ae68340
	*/
	public static function generatePath(?pattern:String, ?params:EitherType<String, Location>):String;
}

