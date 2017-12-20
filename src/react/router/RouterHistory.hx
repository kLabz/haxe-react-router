package react.router;

import haxe.extern.EitherType;

typedef RouterHistory = {
	/**
		The number of entries in the history stack.
	*/
	var length:Int;

	/**
		The current action.
	*/
	var action:RouterAction;

	/**
		The current location.
	*/
	var location:RouterLocation;

	/**
		Pushes a new entry onto the history stack.
	*/
	var push:String->?Dynamic->Void;

	/**
		Replaces the current entry on the history stack.
	*/
	var replace:String->?Dynamic->Void;

	/**
		Moves the pointer in the history stack by n entries.
	*/
	var go:Int->Void;

	/**
		Equivalent to go(-1).
	*/
	var goBack:Void->Void;

	/**
		Equivalent to go(1).
	*/
	var goForward:Void->Void;

	/**
		Prevents navigation.
	*/
	var block:EitherType<String, RouterLocation->RouterAction->String>->(Void->Void);
}

