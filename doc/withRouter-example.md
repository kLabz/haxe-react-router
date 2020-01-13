# Example usage of `withRouter` with `react-next`

```haxe
import react.router.ReactRouter;
import react.router.Route.RouteRenderProps;

private typedef Props = {
    > PublicProps,
    > RouteRenderProps,
}

private typedef PublicProps = {
    // ...
}

@:publicProps(PublicProps)
@:wrap(ReactRouter.withRouter)
class MyComponent extends ReactComponentOfProps<Props> {
}
```
