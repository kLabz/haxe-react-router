package react.router.lazy;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;
using Lambda;
#end

@:autoBuild(react.router.lazy.ILazyLoad.LazyLoadMacro.build())
interface ILazyLoad<Const> {}

#if macro
class LazyLoadMacro {
	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();

		var lazyLoadInterface = cls.interfaces.find(function(i) {
			return i.t.get().name == 'ILazyLoad';
		});

		var loaderComponent = extractComponent(cls, fields, "loaderComponent");
		var errorComponent = extractComponent(cls, fields, "errorComponent");

		if (lazyLoadInterface != null) {
			switch (lazyLoadInterface.params[0]) {
				case TInst(_.get() => {kind: KExpr(components)}, _):
					lazyLoadComponents(
						fields,
						components,
						loaderComponent,
						errorComponent
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
		loaderComponent:Null<Expr>,
		errorComponent:Null<Expr>
	) {
		switch (components.expr) {
			case EArrayDecl(values):
				for (c in values) switch (c.expr) {
					case EField(e, field):
						lazyLoadComponent(fields, e.toString() + '.' + field, loaderComponent, errorComponent);
					case EConst(CString(s)), EConst(CIdent(s)):
						lazyLoadComponent(fields, s, loaderComponent, errorComponent);
					default:
				}

			default:
		}
	}

	static function lazyLoadComponent(
		fields:Array<Field>,
		componentName:String,
		loaderComponent:Null<Expr>,
		errorComponent:Null<Expr>
	) {
		var clsType = Context.getType(componentName);

		switch (clsType) {
			case TInst(_.get() => {name: clsName, pack: pack}, _):
				var ident = pack.concat([clsName]);

				fields.push({
					access: [APublic, AStatic],
					name: clsName,
					kind: FProp('get', 'never', macro :react.React.CreateElementType, null),
					pos: Context.currentPos()
				});

				fields.push({
					access: [AStatic, AInline],
					name: 'get_$clsName',
					kind: FFun({
						args: [],
						params: null,
						ret: macro :react.React.CreateElementType,
						expr: macro {
							return function(props) {
								var a = $p{ident}; // Keep a reference so that modular does its job
								var load = Webpack.load($p{ident});

								return react.React.createElement(
									react.router.lazy.Bundle,
									react.ReactUtil.copy(props, {
										load: load,
										loaderComponent: ${generateComponentExpr(loaderComponent)},
										errorComponent: ${generateComponentExpr(errorComponent)}
									})
								);
							};
						}
					}),
					pos: Context.currentPos()
				});

			default:
		}
	}

	static function generateComponentExpr(componentType:Null<Expr>):Expr {
		if (componentType == null) return macro js.Lib.undefined;
		return componentType;
	}
}
#end

