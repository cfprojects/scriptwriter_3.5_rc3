<cfcomponent displayname="YUICSSCompressor" extends="org.mgersting.scriptwriter.core.CompressorBase" output="no">
	
	
	<cfset variables.Instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfscript>
			setJarPath(ExpandPath("/org/mgersting/scriptwriter/lib/yuicompressor-2.4.2.jar"));
			setClass("com.yahoo.platform.yui.compressor.CssCompressor");
			super.init();
			return this;
		</cfscript>
	</cffunction>
	
	
	<!--- compress() --->
	<cffunction name="compress" access="public" output="no" returntype="string">
		<cfargument name="sOriginalString" type="string" required="yes" />
		<cfset var local = {} />
		
		<cfscript>
			local.jInput = getJStringReader().init(arguments.sOriginalString);
			local.jOutput = getJStringWriter().init();
			local.oCompressorInstance = getCompressor().init(local.jInput);
			local.oCompressorInstance.compress(local.jOutput,-1);
			local.jInput.close();
			local.sOutput = local.jOutput.toString();
			local.jOutput.close();
			return local.sOutput;
		</cfscript>

	</cffunction>

	
</cfcomponent>