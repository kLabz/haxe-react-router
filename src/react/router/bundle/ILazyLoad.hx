package react.router.bundle;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
#end

#if haxe_loader
@:autoBuild(react.router.bundle.ILazyLoad.LazyLoadMacro.build())
interface ILazyLoad<Const> {}
#end

#if macro
@:access(react.router.bundle.Bundle)
class LazyLoadMacro {
	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();

		var lazyLoadInterface = Lambda.find(cls.interfaces, function(i) {
			return i.t.get().name == 'ILazyLoad';
		});

		var loading = extractComponent(cls, fields, "loading");
		var error = extractComponent(cls, fields, "error");

		if (lazyLoadInterface != null) {
			switch (lazyLoadInterface.params[0]) {
				case TInst(_.get() => {kind: KExpr(components)}, _):
					lazyLoadComponents(
						fields,
						components,
						loading,
						error
					);

				default:
			}
		}

		return fields;
	}

	static function extractComponent(
		cls:ClassType,
		fields:Array<Field>,
		compName:String
	) {
		for (f in fields)
			switch (f) {
				case ({name: compName, kind: FVar(_, expr)}):
					return expr;

				case ({name: compName, kind: FFun(_)}):
					return macro $p{[cls.name, compName]};

				default:
			}
		return null;
	}

	static function lazyLoadComponents(
		fields:Array<Field>,
		components:Expr,
		loading:Null<Expr>,
		error:Null<Expr>
	) {
		switch (components.expr) {
			case EArrayDecl(values):
				for (c in values) switch (c.expr) {
					case EField(e, field):
						lazyLoadComponent(fields, ExprTools.toString(c), loading, error);
					case EConst(CString(s)), EConst(CIdent(s)):
						lazyLoadComponent(fields, s, loading, error);
					default:
				}

			default:
		}
	}

	static function lazyLoadComponent(
		fields:Array<Field>,
		componentPath:String,
		loading:Null<Expr>,
		error:Null<Expr>
	) {
		var ident = componentPath.split('.');
		var clsName = ident[ident.length - 1];

		var loader = react.router.bundle.Bundle._load(
			macro $p{ident},
			generateComponentExpr(loading),
			generateComponentExpr(error)
		);

		var reactTypeCT =
			#if (!react_next && (react < "2.0"))
			macro :react.React.CreateElementType
			#else
			macro :react.ReactType
			#end;

		fields.push({
			access: [APublic, AStatic],
			name: clsName,
			kind: FVar(macro :$reactTypeCT, loader),
			pos: Context.currentPos()
		});
	}

	static function generateComponentExpr(componentType:Null<Expr>):Expr {
		if (componentType == null) return macro null;
		return Bundle.storeExpr(componentType);
	}
}
#end

