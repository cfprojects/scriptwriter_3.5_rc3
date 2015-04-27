<cfcomponent displayname="JSMin" extends="org.mgersting.scriptwriter.core.CompressorBase" hint="Basic wrapper CFC for the MagnoliaBox implementation of JSMIN.">

	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfscript>
			//GetDirectoryFromPath(GetCurrentTemplatePath())
			setJarPath(ExpandPath("/org/mgersting/scriptwriter/lib/jsmin.jar"));
			setClass("com.magnoliabox.jsmin.JSMin");
			super.init();
			return this;
		</cfscript>
	</cffunction>
	


	<!--- compress() --->
	<cffunction name="compress" access="public" returntype="string">
		<cfargument name="sOriginalString" type="string" required="yes">
		<cfset var local = {} />
		
		
		
		<cfscript>
			// Create a JavaOutputStream
			local.jOutput = getJOutputStream().init();
			
			// Create a JavasStringReader and pass in the source code (original string)
			local.jInput = getJStringReader().init(arguments.sOriginalString);
			
			// Init the JsMin instance, the run the compression
			local.jJSMinInstance = getCompressor().init(local.jInput, local.jOutput);
			local.jJSMinInstance.jsmin();
			
			// Close out the input reader
			local.jInput.close();
			
			// Save the output results to a local variable and close the output stream
			local.sOutput = local.jOutput.toString();
			local.jOutput.close();
			
			// return the result
			return local.sOutput;
		</cfscript>

		
	</cffunction>
	
</cfcomponent>
