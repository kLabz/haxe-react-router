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

	// Note: all props will also be passed to the <a> element via spread,
	// so className, title, id and such are accepted too.
	// This list is not exhaustive.
	@:optional var id:String;
	@:optional var className:String;
	@:optional var target:String;
	@:optional var title:String;
	@:optional var style:Dynamic;
	@:optional var onClick:haxe.Constraints.Function;
}

/**
	Provides declarative, accessible navigation around your application.
	See https://reacttraining.com/react-router/web/api/Link
*/
@:jsRequire('react-router-dom', 'Link')
extern class Link extends ReactComponentOfProps<LinkProps> {}

