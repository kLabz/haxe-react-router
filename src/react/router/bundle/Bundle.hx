package react.router.bundle;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

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
		classRef = storeExpr(classRef);

		if (!isNull(loaderComponent))
			loaderComponent = storeExpr(loaderComponent);

		if (!isNull(errorComponent))
			errorComponent = storeExpr(errorComponent);

		return _load(classRef, loaderComponent, errorComponent);
	}

	#if macro
	static var N_LOADERS:Int = 0;

	public static function addHook() {
		Context.onGenerate(onGenerate);
	}

	public static function _load(
		classRef:Expr,
		loaderComponent:Expr,
		errorComponent:Expr
	):Expr {
		ensureExposed(classRef);

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

	public static function storeExpr(expr:Expr):Expr {
		try {
			return Context.storeTypedExpr(Context.typeExpr(expr));
		} catch (e:Error) {
			Context.fatalError(e.message, e.pos);
			return macro null;
		}
	}

	static function isNull(e:Expr):Bool {
		return ExprTools.toString(e) == "null";
	}

	static var typesToExpose:Array<String>;

	static function ensureExposed(classRef:Expr) {
		var t = Context.typeof(classRef);

		switch (t) {
			case TType(_.get() => cls, _):
				if (!cls.meta.has(':expose')) {
					var tpath = cls.module;
					if (tpath != null) {
						if (typesToExpose == null) typesToExpose = [];
						typesToExpose.push(tpath);
					}
				}

			default:
		}
	}

	public static function extractTPath(t:Type):Null<String> {
		return switch(TypeTools.toComplexType(t)) {
			case TPath(p):
				var pack = p.pack;
				pack.push(p.name);
				if (p.sub != null) pack.push(p.sub);
				pack.join('.');
			default: null;
		};
	}

	static function onGenerate(types:Array<Type>) {
		if (typesToExpose == null) return;

		for (t in types) {
			var tpath = extractTPath(t);
			if (Lambda.has(typesToExpose, tpath)) {
				var cls = TypeTools.getClass(t);
				cls.meta.add(':expose', [macro 'default'], cls.pos);
				typesToExpose.remove(tpath);
			}
		}
	}
	#end
	#else
	public static function addHook() {}
	#end
}
