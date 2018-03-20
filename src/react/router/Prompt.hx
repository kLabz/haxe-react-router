package react.router;

import history.TransitionManager.TPrompt;
import react.ReactComponent;

typedef PromptProps = {
	/**
		The message to prompt the user with when they try to navigate away.

		Will be called with the next location and action the user is attempting
		to navigate to. Return a string to show a prompt to the user or true to
		allow the transition.
	*/
	var message:TPrompt;

	/**
		Instead of conditionally rendering a <Prompt> behind a guard, you can
		always render it but pass when={true} or when={false} to prevent or
		allow navigation accordingly.
	*/
	@:optional var when:Bool;
}

/**
	Used to prompt the user before navigating away from a page. When your
	application enters a state that should prevent the user from navigating away
	(like a form is half-filled out), render a <Prompt>.

	See https://reacttraining.com/react-router/core/api/Prompt
*/
@:jsRequire('react-router', 'Prompt')
extern class Prompt extends ReactComponentOfProps<PromptProps> {}

