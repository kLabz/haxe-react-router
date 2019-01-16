package react.router;

import haxe.extern.EitherType;
import history.Location;
import js.html.HtmlElement;
import react.ReactComponent;

typedef LinkProps = {
	/**
		The path or location to link to.
	*/
	var to:EitherType<String, Location>;

	/**
		When true, clicking the link will replace the current entry in the
		history stack instead of adding a new one.
	*/
	@:optional var replace:Bool;

	/**
		Allows access to the underlying ref of the component.
	*/
	@:optional var innerRef:HtmlElement->Void;

	#if react_next
	@:optional var children:ReactFragment;
	#else
	@:optional var children:ReactElement;
	#end
}

/**
	Provides declarative, accessible navigation around your application.
	See https://reacttraining.com/react-router/web/api/Link
*/
@:acceptsMoreProps
@:jsRequire('react-router-dom', 'Link')
extern class Link extends ReactComponentOfProps<LinkProps> {}

