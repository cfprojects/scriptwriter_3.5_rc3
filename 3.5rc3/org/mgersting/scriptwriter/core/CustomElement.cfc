<cfcomponent displayname="CustomElement" extends="org.mgersting.scriptwriter.core.ElementBase" output="no">
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="org.mgersting.scriptwriter.core.ElementBase">
		<cfargument name="path" type="string" required="no" default="" />
		<cfargument name="src" type="string" required="no" default="" />
		<cfargument name="minify" type="boolean" required="no" default="false" />
		<cfargument name="outputPath" type="string" required="no" default="" />
		<cfargument name="compressor" type="any" required="no" default="" />
		<cfargument name="mode" type="string" required="no" default="lazy" />
		<cfargument name="keyDelimiter" type="string" required="no" default="" />
		<cfargument name="keys" type="struct" required="no" default="#StructNew()#" />
		
		<cfscript>
			
			// Load the parent class init.
			super.init(
				sourcePath = arguments.path, 
				src = arguments.src, 
				minify = arguments.minify, 
				outputPath = arguments.outputPath,
				compressor = arguments.compressor,
				writeMode = arguments.mode,
				keyDelimiter = arguments.keyDelimiter,
				keys = arguments.keys
			);
			
			// Set the custom external output format for this object type.
			setExternalOutputFormat("#getPreferredPath()#");
			
			// If the source was passed directly in (via the 'src' argument), we can possibly use it
			// to set the format for the inline approach.  However, we need to check and see if it was
			// minimized too, in which case that'll what we'll want to use.
			if (arguments.src NEQ "") {
				if (getMinify()) {
					setInlineOutputFormat("#getSourceMin()#");
				}
				else {
					setInlineOutputFormat("#arguments.src#");
				}
			}
			
			return this;
			
		</cfscript>
		
	</cffunction>
	
	
</cfcomponent>