package react.router;

import react.router.Route.RouteMatchProps;
import react.React.CreateElementType;

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
	public static function withRouter(component:CreateElementType):CreateElementType;
}

