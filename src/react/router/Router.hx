package react.router;

import history.History;
import react.ReactComponent;

typedef RouterProps = {
	/**
		A history object to use for navigation.
	*/
	var history:History;

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
	The common low-level interface for all router components. Typically apps
	will use one of the high-level routers instead:
		<BrowserRouter>
		<HashRouter>
		<MemoryRouter>
		<NativeRouter>
		<StaticRouter>

	The most common use-case for using the low-level <Router> is to synchronize
	a custom history with a state management lib like Redux or Mobx. Note that
	this is not required to use state management libs alongside React Router,
	it’s only for deep integration.

	See https://reacttraining.com/react-router/web/api/Router
*/
@:jsRequire('react-router', 'Router')
extern class Router extends ReactComponentOfProps<RouterProps> {}

