package react.router.bundle;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

#if (haxe_ver < 4)
typedef ObjectField = {field:String, expr:Expr};
#end

class Bundle {
	#if haxe_loader
	public static macro function load(
		classRef:Expr,
		?loaderComponent:Expr = null,
		?errorComponent:Expr = null
	):Expr {
		classRef = Context.storeTypedExpr(Context.typeExpr(classRef));

		if (!isNull(loaderComponent))
			loaderComponent = Context.storeTypedExpr(Context.typeExpr(loaderComponent));

		if (!isNull(errorComponent))
			errorComponent = Context.storeTypedExpr(Context.typeExpr(errorComponent));

		return _load(classRef, loaderComponent, errorComponent);
	}

	#if macro
	static var N_LOADERS:Int = 0;

	static function _load(
		classRef:Expr,
		loaderComponent:Expr,
		errorComponent:Expr
	):Expr {
		var props:Array<ObjectField> = [];
		props.push({expr: macro Webpack.load($classRef), field: "loader"});
		if (!isNull(loaderComponent)) props.push({expr: loaderComponent, field: "loading"});
		if (!isNull(errorComponent)) props.push({expr: errorComponent, field: "error"});

		var propsExpr = {expr: EObjectDecl(props), pos: Context.currentPos()};

		var loaderName = 'BundleLoader${++N_LOADERS}';
		var loaderPack = ['react', 'router', 'bundle'];

		Context.defineType({
			kind: TDClass(null, [], false),
			name: loaderName,
			pack: loaderPack,
			pos: Context.currentPos(),
			fields: (macro class {
				public static function render(props) {
					return react.React.createElement(
						react.router.bundle.BundleWrapper,
						react.ReactUtil.copy(props, ${propsExpr})
					);
				}
			}).fields,
		});

		return macro $p{loaderPack.concat([loaderName])}.render;
	}

	static function isNull(e:Expr):Bool {
		return ExprTools.toString(e) == "null";
	}
	#end
	#end
}
