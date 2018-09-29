package react.router;

import react.ReactComponent;

typedef BrowserRouterProps = {
	/**
		The base URL for all locations. If your app is served from a
		sub-directory on your server, you’ll want to set this to the
		sub-directory. A properly formatted basename should have a leading
		slash, but no trailing slash.
	*/
	@:optional var basename:String;

	/**
		A function to use to confirm navigation. Defaults to using
		window.confirm.
	*/
	@:optional var getUserConfirmation:String->(Bool->Void)->Void;

	/**
		If true the router will use full page refreshes on page navigation. You
		probably only want this in browsers that don’t support the HTML5 history
		API.
	*/
	@:optional var forceRefresh:Bool;

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
	A <Router> that uses the HTML5 history API (pushState, replaceState and the
	popstate event) to keep your UI in sync with the URL.
*/
@:jsRequire('react-router-dom', 'BrowserRouter')
extern class BrowserRouter extends ReactComponentOfProps<BrowserRouterProps> {}

