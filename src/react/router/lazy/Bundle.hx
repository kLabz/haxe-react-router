package react.router.lazy;

import js.Promise;
import react.Partial;
import react.React;
import react.ReactComponent;
import react.ReactMacro.jsx;

typedef BundleProps = {
	var load:Promise<Dynamic>;
	@:optional var loaderComponent:CreateElementType;
	@:optional var errorComponent:CreateElementType;
}

private typedef BundleState = {
	var module:Null<Class<ReactComponent>>;
	var error:Bool;
}

private abstract BundledComponent(Class<ReactComponent>) to Class<ReactComponent> {
	public function firstLoad():Bool {
		var firstLoad:Bool = untyped this.__alreadyLoaded == null;
		untyped this.__alreadyLoaded = true;
		return firstLoad;
	}

	public function getOnLoad():Null<Void->Void> {
		return untyped this.onLoad;
	}
}

class Bundle extends ReactComponentOf<BundleProps, BundleState> {
	static var defaultProps:Partial<BundleProps> = {
		loaderComponent: Bundle.DefaultLoader,
		errorComponent: Bundle.DefaultError
	};

	var available:Bool;

	function new(props) {
		super(props);

		this.state = {
			module: null,
			error: false
		}
	}

	override public function render() {
		if (state.error) return React.createElement(props.errorComponent, {});

		var moduleProps = {};
		for (field in Reflect.fields(props))
			if (field != "load")
				Reflect.setField(moduleProps, field, Reflect.field(props, field));

		return state.module != null
			? React.createElement(state.module, moduleProps)
			: React.createElement(props.loaderComponent, {});
	}

	override function componentWillMount() {
		available = true;
		load(props);
	}

	override function componentWillUnmount() {
		available = false;
	}

	// TODO: handle @:jsxStatic somehow
	function load(props:BundleProps) {
		setState({module: null, error: false}, function() {
			props.load
				.then(function(mod:Dynamic) {
					if (!available) return;

					var def = untyped mod['default'];
					var module:BundledComponent = def != null ? def : mod;

					if (module.firstLoad()) {
						var onLoad:Void->Void = module.getOnLoad();
						if (onLoad != null) return setState({module: module}, onLoad);
					}

					setState({module: module, error: false});
				})
				.catchError(function(e:Dynamic) {
					if (!available) return;

					#if debug
					js.Browser.console.error('Error loading module: $e');
					#end

					setState({error: true});
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

