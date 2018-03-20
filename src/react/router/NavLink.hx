package react.router;

import history.Location;
import react.ReactComponent;
import react.router.Link.LinkProps;

typedef NavLinkProps = {
	> LinkProps,

	/**
		The class to give the element when it is active. The default given
		class is active. This will be joined with the className prop.
	*/
	@:optional var activeClassName:String;

	/**
		The styles to apply to the element when it is active.
	*/
	@:optional var activeStyle:Dynamic;

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

	/**
		A function to add extra logic for determining whether the link is
		active. This should be used if you want to do more than verify that the
		link’s pathname matches the current URL’s pathname.
	*/
	@:optional var isActive:RouterMatch->Location->Bool;

	/**
		The isActive compares the current history location (usually the current
		browser URL). To compare to a different location, a location can be
		passed.
	*/
	@:optional var location:Location;
}

/**
	A special version of the <Link> that will add styling attributes to the
	rendered element when it matches the current URL.
	See https://reacttraining.com/react-router/web/api/NavLink
*/
@:jsRequire('react-router-dom', 'NavLink')
extern class NavLink extends ReactComponentOfProps<NavLinkProps> {}

