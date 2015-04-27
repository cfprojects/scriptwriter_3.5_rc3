<cfcomponent displayname="YUIJavaScriptCompressor" extends="org.mgersting.scriptwriter.core.CompressorBase" output="no">
	
	
	<cfset variables.Instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfscript>
			setJarPath(ExpandPath("/org/mgersting/scriptwriter/lib/yuicompressor-2.4.2.jar"));
			setClass("com.yahoo.platform.yui.compressor.JavaScriptCompressor");
			super.init();
			return this;
		</cfscript>
	</cffunction>
	
	
	<!--- compress() --->
	<cffunction name="compress" access="public" output="no" returntype="string">
		<cfargument name="sOriginalString" type="string" required="yes" />
		<cfset var local = {} />
		
		<cfscript>
			return arguments.sOriginalString
		</cfscript>

	</cffunction>

	
</cfcomponent>