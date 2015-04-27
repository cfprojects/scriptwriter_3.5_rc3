<cfcomponent displayname="ElementBase" hint="This is an abstract class for Scripts, Styles, and any other ScriptWriter Elements that come into being.">

	<!--- Properties --->
	<cfproperty name="sourcePath" type="string" />
	<cfproperty name="outputPath" type="string" />
	<cfproperty name="sourceFull" type="string" />
	<cfproperty name="sourceFullIsLoaded" type="boolean" />
	<cfproperty name="sourceMin" type="string" />
	<cfproperty name="sourceMinIsLoaded" type="string" />
	<cfproperty name="minify" type="boolean" />
	<cfproperty name="compressor" type="any" />
	<cfproperty name="externalOutputFormat" type="string" />
	<cfproperty name="inlineOutputFormat" type="string" />
	<cfproperty name="keyDelimiter" type="string" />
	<cfproperty name="keys" type="struct" />
	
	<cfset variables.Instance = {} />


	<!--- init() --->
	<cffunction name="init" access="public" returntype="org.mgersting.scriptwriter.core.ElementBase">
		<cfargument name="sourcePath" type="string" required="no" default="">
		<cfargument name="src" type="string" required="no" default="">
		<cfargument name="minify" type="boolean" required="no" default="false">
		<cfargument name="outputPath" type="string" required="no" default="">
		<cfargument name="compressor" type="any" required="no" default="" />
		<cfargument name="writeMode" type="string" required="no" default="lazy" />
		<cfargument name="keyDelimiter" type="any" required="no" default="" />
		<cfargument name="keys" type="struct" required="no" default="#StructNew()#" />
		<cfargument name="engine" type="any" required="no" default="" />
		<cfscript>
		
			// Set up our basic property values from the arguments passed in.
			setSourcePath(arguments.sourcePath);
			setSourceFull(arguments.src);
			setSourceMin("");
			setMinify(arguments.minify);
			setOutputPath(arguments.outputPath);
			setCompressor(arguments.compressor);
			setWriteMode(arguments.writeMode);
			setKeyDelimiter(arguments.keyDelimiter);
			setKeys(arguments.keys);
			setEngine(arguments.engine);
			
			// It's possible, based on the combination of arguments passed in
			// that the full source of this item has already been loaded into the object.
			// Let's check the situation and mark the source available accordingly
			checkSourceFullIsLoaded();
			
			// Look at the variable struct to see if anything was passed in.  If so, we need to process.
			if (NOT StructIsEmpty(getKeys())) {
				processInternalKeys();
			}
			
			// Look to see if an engine has been applied
			if (IsObject(getEngine())) {
				if (NOT checkSourceFullIsLoaded()) {
					local.sFullSource = FileRead(ExpandPath(getSourcePath()));
					setSourceFull(local.sFullSource);
				}
				setSourceFull(getEngine().compile(getSourceFull()));
			}
			
			// At this point, we need to determine if the developer is requesting minification.
			if (getMinify()) {
				
				// Let's confirm that the compressor is an object.
				if (NOT IsObject(getCompressor())) {
					throw("You the set the element #arguments.sourcePath# to be minified, but the associated compressor is not an object. It may not have been intialized with ScriptWriter.");
				}
				
				// Next, we need to make sure that we have access to the full source to minify.  This can
				// come from two places - it could have been provided by the 'sourcePath' argument, in which case
				// we need to confirm that that file exists.  Second, it could have been provided directly via
				// the 'src' argument, in which case it would already be marked as loaded. (line 43)
				if (NOT checkSourceFullIsLoaded()) {
					
					// OK, the source isn't loaded (so, it wasn't provided via the 'src' argument).
					// Let's load the source from the 'sourcePath' argument instead, then compress it.
					local.sFullSource = FileRead(ExpandPath(getSourcePath()));
					setSourceFull(local.sFullSource);
					
				}
				
				// Regardless of whether it was passed directly or read from disk, we should now have a copy of the
				// the full source.  We can now minify it and set it back to the object.
				setSourceMin(compress());
				
			}
			
			// Now that we've determined whether or not to minify the item, now we need to determine
			// whether or not to write anything back to the file system.  Basically, if an outputPath
			// argument is passed in we need to look further.
			if (getOutputPath() NEQ "") {
				
				// OK, so an outputPath has been set.  By default, writeMode is set to 'lazy', in which
				// case if the outputPath file already exists, we don't want to write a new one. But, if
				// the writeMode is eager, we write a new one every time.
				if ((getWriteMode() EQ "eager") OR (NOT FileExists(ExpandPath(getOutputPath())))) {
					writeFile();
				}
				
			}
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	
	<!--- checkSourceFullIsLoaded() --->
	<cffunction name="checkSourceFullIsLoaded" access="public" returntype="any">
		<cfscript>
			if (getSourceFull() NEQ "") {
				setSourceFullIsLoaded(true);
				return true;	
			}
			else {
				setSourceFullIsLoaded(false);
				return false;
			}
		</cfscript>
	</cffunction>
	
		
	<!--- getPreferredSource() --->
	<cffunction name="getPreferredSource" access="public" returntype="string">
		<cfscript>
			if (getMinify()) {
				return getSourceMin();	
			}
			else {
				
				if (NOT checkSourceFullIsLoaded()) {
					local.sFullSource = FileRead(ExpandPath(getSourcePath()));
					setSourceFull(local.sFullSource);	
				}
				return getSourceFull();
			}
		</cfscript>
	</cffunction>
	
	
	<!--- getPreferredPath() --->
	<cffunction name="getPreferredPath" access="public" returntype="string">
		<cfscript>
			if (getMinify()) {
				return getOutputPath();
			}
			else {
				return getSourcePath();	
			}
		</cfscript>
	</cffunction>
	
	
	<!--- getOutputFormat()--->
	<cffunction name="getOutputFormat" access="public" returntype="any">
		<cfscript>
			
			// If no input or output files are provided and the full version of the source is
			// available, this must be an inline script.
			if ((getSourcePath() EQ "") AND (getOutputPath() EQ "") AND (getSourceFull() NEQ "")) {
				return getInlineOutputFormat();													   
			}
			
			// Anytime an output path is provided, assume external
			if (getOutputPath() NEQ "") {
				return getExternalOutputFormat();
			}
			
			if (getSourcePath() NEQ "") {
				return getExternalOutputFormat();
			}
			
		</cfscript>
	</cffunction>
	
	
	<!--- processInternalKeys() --->
	<cffunction name="processInternalKeys" access="public" returntype="any">
		<cfscript>
			var local = {};
			local.sProcessedSource = getPreferredSource();
			local.sKeyList = StructKeyList(getKeys());
			for (var i=1; i LTE ListLen(local.sKeyList); i=i+1) {
				local.sFullKey = getKeyDelimiter() & ListGetAt(local.sKeyList,i);
				local.sProcessedSource = REReplaceNoCase(local.sProcessedSource, local.sFullKey, StructFind(getKeys(), ListGetAt(local.sKeyList,i)), "ALL");
			}
		
			setSourceFull(local.sProcessedSource);
			
		</cfscript>
	</cffunction>
	
	
	<!--- compress() --->
	<cffunction name="compress" access="public" returntype="any">
		<cfscript>
			return getCompressor().compress(getSourceFull());
		</cfscript>
	</cffunction>
	
	
	<!--- writeFile() --->
	<cffunction name="writeFile" access="public" returntype="any">
		<cfscript>
			FileWrite(ExpandPath(getOutputPath()),getPreferredSource());
		</cfscript>
	</cffunction>
	
	
	<!--- getSourcePath() --->
	<cffunction name="getSourcePath" access="public" returntype="string">
		<cfreturn variables.Instance["sourcePath"] />
	</cffunction>
	
	
	<!--- setSourcePath() --->
	<cffunction name="setSourcePath" access="public" returntype="string">
		<cfargument name="sPath" type="string" required="yes" />
		<cfset variables.Instance["sourcePath"] = arguments.sPath />
	</cffunction>
	
	
	<!--- getOutputPath() --->
	<cffunction name="getOutputPath" access="public" returntype="string">
		<cfreturn variables.Instance["outputPath"] />
	</cffunction>
	
	
	<!--- setOutputPath() --->
	<cffunction name="setOutputPath" access="public" returntype="string">
		<cfargument name="sPath" type="string" required="yes" />
		<cfset variables.Instance["outputPath"] = arguments.sPath />
	</cffunction>

	
	<!--- getMinify() --->
	<cffunction name="getMinify" access="public" returntype="boolean">
		<cfreturn variables.Instance["minify"] />
	</cffunction>
	
	
	<!--- setMinify() --->
	<cffunction name="setMinify" access="public" returntype="any">
		<cfargument name="blnMinify" type="string" required="yes" />
		<cfset variables.Instance["minify"] = arguments.blnMinify />
	</cffunction>
	
	
	<!--- getCompressor() --->
	<cffunction name="getCompressor" access="public" returntype="any">
		<cfreturn variables.Instance["compressor"] />
	</cffunction>
	
	
	<!--- setCompressor() --->
	<cffunction name="setCompressor" access="public" returntype="any">
		<cfargument name="oCompressor" type="any" required="yes" />
		<cfset variables.Instance["compressor"] = arguments.oCompressor />
	</cffunction>
	
	
	<!--- getWriteMode() --->
	<cffunction name="getWriteMode" access="private" returntype="any">
		<cfreturn variables.Instance["writeMode"] />
	</cffunction>
	
	
	<!--- setWriteMode() --->
	<cffunction name="setWriteMode" access="private" returntype="any">
		<cfargument name="writeMode" type="string" required="true" />
		<cfset variables.Instance["writeMode"] = arguments.writeMode />
	</cffunction>
	
	
	<!--- getSourceFullIsLoaded() --->
	<cffunction name="getSourceFullIsLoaded" access="public" returntype="any">
		<cfreturn variables.Instance["sourceFullIsLoaded"] />
	</cffunction>
	
	
	<!--- setSourceFullIsLoaded() --->
	<cffunction name="setSourceFullIsLoaded" access="public" returntype="any">
		<cfargument name="blnState" type="boolean" required="yes" />
		<cfset variables.Instance["sourceFullIsLoaded"] = Arguments.blnState />
	</cffunction>
	
	
	<!--- getExternalOutputFormat() --->
	<cffunction name="getExternalOutputFormat" access="public" returntype="any">
		<cfreturn variables.Instance["externalOutputFormat"] />
	</cffunction>
	
	
	<!--- setExternalOutputFormat() --->
	<cffunction name="setExternalOutputFormat" access="public" returntype="any">
		<cfargument name="sOutputRefFormat" type="string" required="yes" />
		<cfset variables.Instance["externalOutputFormat"] = Arguments.sOutputRefFormat />
	</cffunction>
	
	
	<!--- getInlineOutputFormat() --->
	<cffunction name="getInlineOutputFormat" access="public" returntype="any">
		<cfreturn variables.Instance["inlineOutputFormat"] />
	</cffunction>
	
	
	<!--- setInlineOutputFormat() --->
	<cffunction name="setInlineOutputFormat" access="public" returntype="any">
		<cfargument name="sOutputRefFormat" type="string" required="yes" />
		<cfset variables.Instance["inlineOutputFormat"] = Arguments.sOutputRefFormat />
	</cffunction>
	
	
	<!--- getSourceFull() --->
	<cffunction name="getSourceFull" access="public" returntype="string">
		<cfreturn variables.Instance["sourceFull"] />
	</cffunction>
	
	
	<!--- setSourceFull() --->
	<cffunction name="setSourceFull" access="public" returntype="string">
		<cfargument name="sSource" type="string" required="yes" />
		<cfset variables.Instance["sourceFull"] = arguments.sSource />
	</cffunction>
	
	
	<!--- getSourceMin() --->
	<cffunction name="getSourceMin" access="public" returntype="string">
		<cfreturn variables.Instance["sourceMin"] />
	</cffunction>
	
	
	<!--- setSourceMin() --->
	<cffunction name="setSourceMin" access="public" returntype="string">
		<cfargument name="sSource" type="string" required="yes" />
		<cfset variables.Instance["sourceMin"] = arguments.sSource />
	</cffunction>
	
	
	<!--- getKeyDelimiter() --->
	<cffunction name="getKeyDelimiter" access="public" returntype="string">
		<cfreturn variables.Instance["keyDelimiter"] />
	</cffunction>
	
	
	<!--- setKeyDelimiter() --->
	<cffunction name="setKeyDelimiter" access="public" returntype="string">
		<cfargument name="sDelimiter" type="string" required="yes" />
		<cfset variables.Instance["keyDelimiter"] = arguments.sDelimiter />
	</cffunction>
	
	
	<!--- getKeys() --->
	<cffunction name="getKeys" access="public" returntype="struct">
		<cfreturn variables.Instance["keys"] />
	</cffunction>
	
	
	<!--- setKeys() --->
	<cffunction name="setKeys" access="public" returntype="void">
		<cfargument name="stKeys" type="struct" required="yes" />
		<cfset variables.Instance["keys"] = arguments.stKeys />
	</cffunction>
	
	
	<!--- getEngine() --->
	<cffunction name="getEngine" access="public" returntype="any" output="no">
		<cfreturn variables.instance["engine"] />
	</cffunction>
	
	
	<!--- setEngine() ---->
	<cffunction name="setEngine" access="public" returntype="any" output="no">
		<cfargument name="engine" type="any" required="yes" />
		<cfset variables.instance["engine"] = arguments.engine />
	</cffunction>
	
		
</cfcomponent>