# Lazy loading with Webpack Haxe Loader

This is an example using webpack-haxe-loader and this lib to achieve async routes.

In your main router:

```haxe
import react.ReactMacro.jsx;
import react.router.BrowserRouter;
import react.router.Route;
import react.router.Switch;
import react.router.lazy.Bundle;
import react.router.lazy.ILazyLoad;

// Magic interface with build macro
// To easily create component bundles
class LazyLoad implements ILazyLoad<[
	my.first.app.FirstApp,
	my.second.app.SecondApp,
	my.third.app.ThirdApp
]> {
	// A build macro will create 3 static functions:
	// - FirstApp, which will render my.first.app.FirstApp
	// - SecondApp, which will render my.second.app.SecondApp
	// - ThirdApp, which will render my.third.app.ThirdApp

	// Warning: due to this notation, you cannot lazy load two components with
	// the same name from two different packages.


	// You can also define a loader component, if you want
	// If you don't, a <div className="loader"></div> will be rendered instead.
	static var loaderComponent = my.components.Loader;

	// Same thing for the error component.
	// Both loaderComponent and errorComponent can be either a static var or a
	// static function.
	// At the moment, errorComponent receives no props, but it may receive the
	// error message in the future.
	// If you don't provide any, a <div className="error"></div> will be
	// rendered if the require fails.
	static function errorComponent() {
		return jsx('<div className="error">Error!</div>');
	}
}

@:jsxStatic('render')
class MainRouter {
	public static function render() {
		return jsx('
			<$BrowserRouter>
				<$Switch>
					<$Route path="/first" component=${LazyLoad.FirstApp} />
					<$Route path="/second" component=${LazyLoad.SecondApp} />
					<$Route path="/third" component=${LazyLoad.ThirdApp} />

					<!-- You can also work directly with Bundle -->
					<$Route path="/bundled" component=${BundledApp} />
				</$Switch>
			</$BrowserRouter>
		');
	}

	static function BundledApp() {
		return jsx('
			<$Bundle
				load=${Webpack.load(my.fourth.app.FourthApp)}
				loaderComponent=${my.components.OtherLoader}
			/>
		');
	}
}
```

An example async component:

```haxe
package my.first.app;

import react.ReactComponent;
import react.router.Route.RouteRenderProps;

@:expose('default')
class FirstApp extends ReactComponentOfProps<RouteRenderProps> {
	// If you want to execute code when this bundle is _first_ loaded:
	public static function onLoad() {
		// ...
	}

	// ...
}
```


## TODO

* Make it work nicely and seamlessly with server side rendering
* Link to the async redux store trick using `onLoad()`

