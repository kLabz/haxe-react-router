package react.router;

import haxe.extern.EitherType;
import history.Location;
import react.ReactComponent;

typedef MemoryRouterProps = {
	/**
		An array of locations in the history stack.
	*/
	@:optional var initialEntries:Array<EitherType<String, Location>>;

	/**
		The initial location’s index in the array of initialEntries.
	*/
	@:optional var initialIndex:Int;

	/**
		A function to use to confirm navigation. Defaults to using
		window.confirm.
	*/
	@:optional var getUserConfirmation:String->(Bool->Void)->Void;

	/**
		The length of location.key. Defaults to 6.
	*/
	@:optional var keyLength:Int;

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
	A <Router> that keeps the history of your “URL” in memory (does not read or
	write to the address bar). Useful in tests and non-browser environments like
	React Native.

	See https://reacttraining.com/react-router/web/api/MemoryRouter
*/
@:jsRequire('react-router', 'MemoryRouter')
extern class MemoryRouter extends ReactComponentOfProps<MemoryRouterProps> {}

