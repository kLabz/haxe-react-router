# Haxe react-router 4

A Haxe library offering externs for version 4 of the [react-router](https://github.com/ReactTraining/react-router) library.
For version 3, see [haxe-react-router](https://github.com/elsassph/haxe-react-router) by [elsassph](https://github.com/elsassph).

Compatibility with `react-router` javascript lib:
* `0.1.X` => `4.2.X`
* `0.2.X` => `4.3.X`

## Installation

Using haxelib:
```
haxelib install react-router-4
```

## Usage

An extensive documentation is available [here](https://reacttraining.com/react-router/web/)
for the javascript `react-router` library and is mostly applicable for this library too.

### React Router API

#### `ReactRouter.matchPath(pathname:String, props:RouteMatchProps):Null<RouterMatch>`

This lets you use the same matching code that `<Route>` uses except outside of
the normal render cycle, like gathering up data dependencies before rendering
on the server.

See https://reacttraining.com/react-router/web/api/matchPath

#### `ReactRouter.withRouter(component:CreateElementType):CreateElementType`

You can get access to the history object’s properties and the closest
`<Route>`'s match via the withRouter higher-order component. withRouter will
re-render its component every time the route changes with the same props as
`<Route>` render props: `{ match, location, history }`.

See https://reacttraining.com/react-router/web/api/withRouter

With `haxe-react` version `1.4.1+` (not released at the moment, but this is available by using the git version),
you can use `@:wrap` to easily wrap your component with a `withRouter` call:

```haxe
@:wrap(react.router.ReactRouter.withRouter)
class MyComponent extends ReactComponentOfProps<Props> {
}
```

### React Router components

React Router components are available in the `react.router` package.

Each component has its typed props with comments and a link to the javascript `react-router` documentation,
which applies to this library.

List of available components:

 * [`react.router.Router`](src/react/router/Router.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Router)
 * [`react.router.BrowserRouter`](src/react/router/BrowserRouter.hx) - [Documentation](https://reacttraining.com/react-router/web/api/BrowserRouter)
 * [`react.router.HashRouter`](src/react/router/HashRouter.hx) - [Documentation](https://reacttraining.com/react-router/web/api/HashRouter)
 * [`react.router.MemoryRouter`](src/react/router/MemoryRouter.hx) - [Documentation](https://reacttraining.com/react-router/web/api/MemoryRouter)
 * [`react.router.StaticRouter`](src/react/router/StaticRouter.hx) - [Documentation](https://reacttraining.com/react-router/web/api/StaticRouter)
 * [`react.router.Link`](src/react/router/Link.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Link)
 * [`react.router.NavLink`](src/react/router/NavLink.hx) - [Documentation](https://reacttraining.com/react-router/web/api/NavLink)
 * [`react.router.Switch`](src/react/router/Switch.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Switch)
 * [`react.router.Redirect`](src/react/router/Redirect.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Redirect)
 * [`react.router.Route`](src/react/router/Route.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Route)
 * [`react.router.Prompt`](src/react/router/Prompt.hx) - [Documentation](https://reacttraining.com/react-router/web/api/Prompt)

### Code splitting with `haxe-loader`

When using the webpack [`haxe-loader`](https://github.com/jasononeil/webpack-haxe-loader) library,
you can use `react.router.bundle.Bundle.load(...)` to split your application into bundles directly in your routes:

```haxe
import react.ReactMacro.jsx;
import react.router.BrowserRouter;
import react.router.Route;
import react.router.Switch;
import react.router.bundle.Bundle;

class MainRouter extends ReactComponent {
    override public function render() {
        return jsx('
            <$BrowserRouter>
                <$Switch>
                    <!-- Using default loader component (`<div className="loader" />`) -->
                    <!-- and default error component (`<div className="error" />`) -->
                    <!-- /!\\ Warning: your component should have the `@:expose("default")` meta -->
                    <!-- See example below in "Bundle initialization code" -->
                    <$Route
                        path="/bundle1"
                        component=${Bundle.load(first.FirstBundle)}
                    />

                    <!-- Using custom loader and/or error component -->
                    <!-- The error component will get an `error` prop with the load error as `Dynamic` -->
                    <$Route
                        path="/bundle2"
                        component=${Bundle.load(second.SecondBundle, CustomLoader, CustomError)}
                    />
                </$Switch>
            </$BrowserRouter>
        ');
    }
}
```

#### Usage with `@:jsxStatic` components

See [the `@:jsxStatic` original PR on haxe-react](https://github.com/massiveinteractive/haxe-react/pull/81) if you don't know about `@:jsxStatic` components.  Documentation will be added on `haxe-react` later.

You cannot directly load `@:jsxStatic` components with current (`1.4.0`) haxe-react version.
There is a merged [PR](https://github.com/massiveinteractive/haxe-react/pull/107) to make it work.
This is not released at the moment, but until `1.4.1+` you can use git version of `haxe-react`.

If you really need to, another workaround is to use a wrapper around your `@:jsxStatic` component:

```haxe

// In your router
jsx('
    <$Route path="/bundle3" component=${Bundle.load(MyWrapper)} />
');

// In your bundle's module
class MyWrapper extends ReactComponent {
    override public function render() {
        return jsx('
            <$MyComponent {...props} />
        ');
    }
}

@:jsxStatic('render')
class MyComponent {
    public static function render(props:Dynamic) {
        return jsx('<div>My component</div>');
    }
}
```

#### Bundle initialization code

You may want to execute some code when your bundle is first loaded.

When your component is loaded via `Bundle.load(...)` (or `ILazyLoad`, see below), you can define
initialization code to be executed at first load by creating an `onLoad` static method on your component:

Adding `@:expose('default')` should be optional with version `0.0.7+`, but you
should continue to add it, especially if you are using other libraries using
split bundles.

```haxe
import react.ReactComponent;
import react.router.Route.RouteRenderProps;

@:expose('default')
class MyBundle extends ReactComponentOfProps<RouteRenderProps> {
    // If you want to execute code when this bundle is _first_ loaded:
    public static function onLoad() {
        // ...
    }

    // ...
}
```

#### `ILazyLoad` macro (experimental)

If you use custom loaders and/or custom error components, `Bundle.load()` calls can become quite verbose.

There is an experimental API based on macros to define your async routes like this:

```haxe
import react.ReactMacro.jsx;
import react.router.BrowserRouter;
import react.router.Route;
import react.router.Switch;
import react.router.bundle.ILazyLoad;

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
    static var loading = my.components.Loader;

    // Same thing for the error component.
    // Both loaderComponent and errorComponent can be either a static var or a
    // static function.
    // The error component will receive an `error` prop with the load error.
    // If you don't provide any, a <div className="error"></div> will be
    // rendered if the require fails.
    static function error() {
        return jsx('<div className="error">Error!</div>');
    }
}
```

You can then use them in your react-router routes:

```haxe
class MyRouter extends ReactComponent {
    override public function render() {
        return jsx('
            <$BrowserRouter>
                <$Switch>
                    <$Route path="/first" component=${LazyLoad.FirstApp} />
                    <$Route path="/second" component=${LazyLoad.SecondApp} />
                    <$Route path="/third" component=${LazyLoad.ThirdApp} />
                </$Switch>
            </$BrowserRouter>
        ');
    }
}
```

