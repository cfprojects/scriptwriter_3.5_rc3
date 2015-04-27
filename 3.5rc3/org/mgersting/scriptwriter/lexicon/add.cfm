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
		
		// Must have a type
		if (NOT StructKeyExists(fb_.verbInfo.attributes,"type")) {
			fb_throw(
				"fusebox.badGrammar.requiredAttributeMissing",
				"Required attribute is missing",
				"The attribute 'type' is required, for a 'scriptwriter' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
			);
		}
		
		// Must have a region
		if (NOT StructKeyExists(fb_.verbInfo.attributes,"region")) {
			fb_throw(
				"fusebox.badGrammar.requiredAttributeMissing",
				"Required attribute is missing",
				"The attribute 'region' is required, for a 'scriptwriter' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
			);
		}
		
		// Must have either a path or a src
		if ((NOT StructKeyExists(fb_.verbInfo.attributes,"path")) AND (NOT StructKeyExists(fb_.verbInfo.attributes,"src"))) {
			fb_throw(
				"fusebox.badGrammar.requiredAttributeMissing",
				"Required attribute is missing",
				"The attribute 'path' or 'source' is required, for a 'scriptwriter' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#."
			);
		}
		
		fb_.verbInfo.output = "<cfset #fb_.verbInfo.attributes.factory#.add(";
		fb_.verbInfo.output &= "request=#fb_.verbInfo.attributes.request#";
		fb_.verbInfo.output &= ",type='#fb_.verbInfo.attributes.type#'";
		fb_.verbInfo.output &= ",region='#fb_.verbInfo.attributes.region#'";
		
		if (StructKeyExists(fb_.verbInfo.attributes,"group")) {
			fb_.verbInfo.output &= ",group='#fb_.verbInfo.attributes.group#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"path")) {
			fb_.verbInfo.output &= ",path='#fb_.verbInfo.attributes.path#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"src")) {
			fb_.verbInfo.output &= ",src='#fb_.verbInfo.attributes.src#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"minify")) {
			fb_.verbInfo.output &= ",minify=#fb_.verbInfo.attributes.minify#";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"outputPath")) {
			fb_.verbInfo.output &= ",outputPath='#fb_.verbInfo.attributes.outputPath#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"writeMode")) {
			fb_.verbInfo.output &= ",writeMode='#fb_.verbInfo.attributes.writeMode#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"keyDelimiter")) {
			fb_.verbInfo.output &= ",keyDelimiter='#fb_.verbInfo.attributes.keyDelimiter#'";
		}
		
		if (StructKeyExists(fb_.verbInfo.attributes,"keys")) {
			fb_.verbInfo.output &= ",keys=#fb_.verbInfo.attributes.keys#";
		}

		fb_.verbInfo.output &= ")/>";
		fb_appendLine(fb_.verbInfo.output);
		
	}
	else
	{
		//
		// end mode - do nothing
	}
</cfscript>
