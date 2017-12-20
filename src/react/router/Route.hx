package react.router;

import react.React.CreateElementType;
import react.ReactComponent;

typedef RouteRenderProps = {
	var match:RouterMatch;
	var location:RouterLocation;
	var history:RouterHistory;
}

typedef RouteMatchProps = {
	var path:String;
	@:optional var exact:Bool;
	@:optional var strict:Bool;
}

typedef ChildrenRouteProps = {
	var match:Null<RouterMatch>;
	var location:RouterLocation;
	var history:RouterHistory;
}

typedef RouteComponentProps = {
	> RouteRenderProps,
	> RouteMatchProps,
	@:optional var component:CreateElementType;
	@:optional var render:RouteRenderProps->ReactElement;
	@:optional var children:ChildrenRouteProps->ReactElement;
}

/**
	The Route component is perhaps the most important component in React Router
	to understand and learn to use well. Its most basic responsibility is to
	render some UI when a location matches the route’s path.

	There are 3 ways to render something with a <Route>:
		<Route component>
		<Route render>
		<Route children>

	Each is useful in different circumstances. You should use only one of these
	props on a given <Route>. See their explanations below to understand why you
	have 3 options. Most of the time you’ll use component.

	See https://reacttraining.com/react-router/web/api/Route
*/
@:jsRequire('react-router', 'Route')
extern class Route extends ReactComponentOfProps<RouteComponentProps> {}

