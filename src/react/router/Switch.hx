package react.router;

import react.ReactComponent;

typedef SwitchProps = {
	/**
		A location object to be used for matching children elements instead of
		the current history location (usually the current browser URL).
	*/
	var location:RouterLocation;

	/**
		All children of a <Switch> should be <Route> or <Redirect> elements.
		Only the first child to match the current location will be rendered.
	*/
	var children:Dynamic;
}

/**
	Renders the first child <Route> or <Redirect> that matches the location.

	See https://reacttraining.com/react-router/web/api/Switch
*/
@:jsRequire('react-router', 'Switch')
extern class Switch extends ReactComponentOfProps<SwitchProps> {}

