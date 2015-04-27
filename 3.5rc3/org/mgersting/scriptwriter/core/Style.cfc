<cfcomponent displayname="Style" extends="org.mgersting.scriptwriter.core.ElementBase" output="no">
	
	<cfset variables.instance = {} />
	
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
		<cfargument name="media" type="string" required="no" default="screen" />
		<cfargument name="engine" type="any" required="no" default="" />
		
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
				keys = arguments.keys,
				engine = arguments.engine
			);
			
			// Set media type (screen, print, etc)
			setMedia(arguments.media);
			
			// Set the custom external output format for this object type.
			setExternalOutputFormat("<link type=""text/css"" rel=""stylesheet"" href=""#getPreferredPath()#"" media=""#getMedia()#"" />");
			
			// If the source was passed directly in (via the 'src' argument), we can possibly use it
			// to set the format for the inline approach.  However, we need to check and see if it was
			// minimized too, in which case that'll what we'll want to use.
			if (arguments.src NEQ "") {
				if (getMinify()) {
					setInlineOutputFormat("<style>#getSourceMin()#</style>");
				}
				else {
					setInlineOutputFormat("<style>#arguments.src#</style>");
				}
				
			}
			
			return this;
			
		</cfscript>

	</cffunction>
	
	<cffunction name="getMedia" access="public" returntype="string" output="no">
		<cfreturn variables.instance["media"] />
	</cffunction>
	
	<cffunction name="setMedia" access="public" returntype="string" output="no">
		<cfargument name="media" type="string" required="yes" />
		<cfset variables.instance["media"] = arguments.media />
	</cffunction>
	
	
</cfcomponent>