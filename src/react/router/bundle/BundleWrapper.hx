package react.router.bundle;

import js.Promise;
import react.Partial;
import react.React;
import react.ReactComponent;
import react.ReactMacro.jsx;

typedef BundleProps = {
	var loader:Promise<Dynamic>;
	@:optional var loading:CreateElementType;
	@:optional var error:CreateElementType;
}

private typedef BundleState = {
	var module:Null<BundledComponent>;
	var error:Bool;
	var errorMessage:Null<Dynamic>;
}

private abstract BundledComponent(Class<ReactComponent>) {
	public function firstLoad():Bool {
		var firstLoad:Bool = untyped this.__alreadyLoaded == null;
		untyped this.__alreadyLoaded = true;
		return firstLoad;
	}

	public function getOnLoad():Null<Void->Void> {
		return untyped this.onLoad;
	}

	@:to
	public function toCreateElementType():CreateElementType {
		if (untyped this.__jsxStatic != null)
			return untyped this.__jsxStatic;

		return this;
	}
}

class BundleWrapper extends ReactComponentOfPropsAndState<BundleProps, BundleState> {
	static var defaultProps:Partial<BundleProps> = {
		loading: DefaultLoader,
		error: DefaultError
	};

	var available:Bool;

	function new(props) {
		super(props);

		this.state = {
			module: null,
			error: false,
			errorMessage: null
		}
	}

	override public function render() {
		if (state.error)
			return React.createElement(props.error, {error: state.errorMessage});

		var moduleProps = {};
		for (field in Reflect.fields(props))
			switch (field) {
				case "loader", "loading", "error":
				default:
					Reflect.setField(moduleProps, field, Reflect.field(props, field));
			}

		return state.module != null
			? React.createElement(state.module, moduleProps)
			: React.createElement(props.loading, {});
	}

	override function componentWillMount() {
		available = true;
		loadBundle(props);
	}

	override function componentWillUnmount() {
		available = false;
	}

	function loadBundle(props:BundleProps) {
		setState({module: null, error: false}, function() {
			props.loader
				.then(function(mod:Dynamic) {
					if (!available) return;

					var def = untyped mod['default'];
					var module:BundledComponent = def != null ? def : mod;

					if (module.firstLoad()) {
						var onLoad:Void->Void = module.getOnLoad();
						if (onLoad != null) return setState({module: module}, onLoad);
					}

					setState({module: module, error: false, errorMessage: null});
				})
				.catchError(function(e:Dynamic) {
					if (!available) return;

					#if debug
					js.Browser.console.error('Error loading module: $e');
					#end

					setState({error: true, errorMessage: e});
				});
		});
	}

	static function DefaultLoader() {
		return jsx('<div className="loader"></div>');
	}

	static function DefaultError() {
		return jsx('<div className="error"></div>');
	}
}

