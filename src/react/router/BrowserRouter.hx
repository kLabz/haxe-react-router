package react.router;

import react.ReactComponent;

typedef BrowserRouterProps = {
	/**
		The base URL for all locations. If your app is served from a
		sub-directory on your server, you’ll want to set this to the
		sub-directory. A properly formatted basename should have a leading
		slash, but no trailing slash.
	*/
	var basename:String;

	/**
		A function to use to confirm navigation. Defaults to using
		window.confirm.
	*/
	var getUserConfirmation:String->(Bool->Void)->Void;

	/**
		If true the router will use full page refreshes on page navigation. You
		probably only want this in browsers that don’t support the HTML5 history
		API.
	*/
	var forceRefresh:Bool;

	/**
		The length of location.key. Defaults to 6.
	*/
	var keyLength:Int;

	/**
		A single child element to render.
	*/
	var children:ReactElement;
}

/**
	A <Router> that uses the HTML5 history API (pushState, replaceState and the
	popstate event) to keep your UI in sync with the URL.
*/
@:jsRequire('react-router-dom', 'BrowserRouter')
extern class BrowserRouter extends ReactComponentOfProps<BrowserRouterProps> {}

