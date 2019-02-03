package react.router;

import history.History;
import history.Location;
import react.ReactComponent;

#if (!react_next && (react < "2.0"))
private typedef ReactType = react.React.CreateElementType;
#else
import react.ReactType;
#end

typedef RouteRenderProps = {
	@:optional var match:RouterMatch;
	@:optional var location:Location;
	@:optional var history:History;
}

typedef RouteMatchProps = {
	@:optional var path:String;
	@:optional var exact:Bool;
	@:optional var strict:Bool;
	@:optional var sensitive:Bool;
}

typedef ChildrenRouteProps = {
	var match:Null<RouterMatch>;
	var location:Location;
	var history:History;
}

typedef RouteComponentProps = {
	> RouteRenderProps,
	> RouteMatchProps,
	@:optional var component:ReactType;
	#if react_next
	@:optional var render:RouteRenderProps->ReactFragment;
	@:optional var children:ChildrenRouteProps->ReactFragment;
	#else
	@:optional var render:RouteRenderProps->ReactElement;
	@:optional var children:ChildrenRouteProps->ReactElement;
	#end
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

