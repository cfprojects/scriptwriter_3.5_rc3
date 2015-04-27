<cfscript>
	// example custom verb that compiles to a cfset tag that executes
	// the proper inclusion syntax to add scritps or styles via Script Writer
	// usage:
	// 1. add the lexicon declaration to your circuit file:
	//    <circuit xmlns:cf="cf/">
	// 2. use the verb in a fuseaction:
	//    <cf:scriptwriter add="script" path="some path" file="some file" />
	//    <cf:scriptwriter add="style" path="some path" file="some file" />
	//
	// how this works:
	// a. validate the attributes passed in (fb_.verbInfo.attributes)
	// b. in start mode, generate the required CFML
	// c. in end mode, do nothing (this tag does not nest)
	//
	fb_.verbInfo.attributes.defaultFactoryObject = "application.scriptWriter";
	fb_.verbInfo.attributes.activeFactoryObject = "";
	if (fb_.verbInfo.executionMode is "start")
	{
		
		
		// We need to make sure that either a factory reference was passed in
		// or that the default factory name is valid
		if (StructKeyExists(fb_.verbInfo.attributes,"factory")) {
			if (NOT IsDefined("#StructFind(fb_.verbInfo.attributes,"factory")#")) {
				fb_throw(
					"fusebox.badGrammar.requiredAttributeMissing",
					"Factory cannot be found.",
					"The attribute 'factory' was provided, but the corresponding object cannot be found. #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
				);
			}
		}
		else {
			if (NOT IsDefined("#fb_.verbInfo.attributes.defaultFactoryObject#")) {
				fb_throw(
					"fusebox.badGrammar.requiredAttributeMissing",
					"Factory cannot be found.",
					"The attribute 'factory' was not provided. ScriptWriter is attempting to use the default factory object name but the corresponding object cannot be found. #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
				);
			}
			else {
				fb_.verbInfo.attributes.factory = fb_.verbInfo.attributes.defaultFactoryObject;
			}
		}
		
		// We must have a request id
		if (NOT StructKeyExists(fb_.verbInfo.attributes,"request")) {
			fb_throw(
				"fusebox.badGrammar.requiredAttributeMissing",
				"Required attribute is missing",
				"The attribute 'request' is required, for a 'scriptwriter' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
			);
		}
		
		fb_.verbInfo.output = "<cfset #fb_.verbInfo.attributes.factory#.closeRequest(";
		fb_.verbInfo.output &= "request=#fb_.verbInfo.attributes.request#";
		fb_.verbInfo.output &= ")/>";
		fb_appendLine(fb_.verbInfo.output);
		
	}
	else
	{
		//
		// end mode - do nothing
	}
</cfscript>
