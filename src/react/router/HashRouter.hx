package react.router;

import react.ReactComponent;

typedef HashRouterProps = {
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
		The type of encoding to use for window.location.hash.
		Defaults to Slash.
	*/
	@:optional var hashType:HashType;

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

@:enum abstract HashType(String) from String to String {
	var Slash = "slash";
	var NoSlash = "noslash";
	var HashBang = "hashbang";
}

/**
	A <Router> that uses the hash portion of the URL (i.e. window.location.hash)
	to keep your UI in sync with the URL.

	IMPORTANT NOTE: Hash history does not support location.key or location.state.
	In previous versions we attempted to shim the behavior but there were edge
	cases we couldn’t solve. Any code or plugin that needs this behavior won’t
	work. As this technique is only intended to support legacy browsers, we
	encourage you to configure your server to work with <BrowserHistory> instead.

	See https://reacttraining.com/react-router/web/api/HashRouter
*/
@:jsRequire('react-router-dom', 'HashRouter')
extern class HashRouter extends ReactComponentOfProps<HashRouterProps> {}

