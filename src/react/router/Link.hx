package react.router;

import haxe.extern.EitherType;
import react.ReactComponent;

typedef LinkProps = {
	/**
		The path or location to link to.
	*/
	var to:EitherType<String, RouterLocation>;

	/**
		When true, clicking the link will replace the current entry in the
		history stack instead of adding a new one.
	*/
	@:optional var replace:Bool;
}

/**
	Provides declarative, accessible navigation around your application.
	See https://reacttraining.com/react-router/web/api/Link
*/
@:jsRequire('react-router-dom', 'Link')
extern class Link extends ReactComponentOfProps<LinkProps> {}

