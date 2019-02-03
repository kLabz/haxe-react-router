package react.router.bundle;

import js.Promise;
import react.Partial;
import react.React;
import react.ReactComponent;
import react.ReactMacro.jsx;

#if (!react_next && (react < "2.0"))
private typedef ReactType = react.React.CreateElementType;
#else
import react.ReactType;
#end

typedef BundleProps = {
	var loader:Promise<Dynamic>;
	@:optional var loading:ReactType;
	@:optional var error:ReactType;
}

private typedef BundleState = {
	var module:Null<BundledComponent>;
	var error:Bool;
	var errorMessage:Null<Dynamic>;
}

private abstract BundledComponent(Class<ReactComponent>) {
	public function firstLoad():Bool {
		var firstLoad:Bool = untyped this.__loaded == null;
		untyped this.__loaded = true;
		return firstLoad;
	}

	public function getOnLoad():Null<Void->Void> {
		return untyped this.onLoad;
	}

	@:to
	public function toReactType():ReactType {
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

					var module:BundledComponent = mod;
					while (mod != null) {
						module = mod;
						mod = untyped mod['default'];
					}

					if (module.firstLoad()) {
						var onLoad:Void->Void = module.getOnLoad();
						if (onLoad != null) return setState({module: module}, onLoad);
					}

					setState({module: module, error: false, errorMessage: null});
				})
				.catchError(function(e:Dynamic) {
					if (!available) return;

					js.Browser.console.error('Error loading module');
					js.Browser.console.error(e);

					setState({error: true, errorMessage: e});
				});
		});
	}

	public static function DefaultLoader() {
		return jsx('<div className="loader"></div>');
	}

	public static function DefaultError() {
		return jsx('<div className="error"></div>');
	}
}

