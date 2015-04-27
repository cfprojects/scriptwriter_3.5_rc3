<cfcomponent displayname="CompressorBase" output="no" hint="Abstract class for Java-based compressors. Provides utilty methods.">
	
	<cfproperty name="jarPath" type="string" />
	<cfproperty name="class" type="string" />
	<cfproperty name="compressor" type="any" />
	<cfproperty name="jStringReader" type="any" />
	<cfproperty name="jStringWriter" type="any" />
	<cfproperty name="jOutputStream" type="any" />
	<cfset variables.Instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfscript>
			setJStringReader(CreateObject("java","java.io.StringReader"));
			setJStringWriter(CreateObject("java","java.io.StringWriter"));
			setJOutputStream(CreateObject("java","java.io.ByteArrayOutputStream"));
			return this;
		</cfscript>
	</cffunction>
	
	
	<!--- getJarPath() --->
	<cffunction name="getJarPath" access="public" output="no" returntype="string">
		<cfreturn variables.Instance["jarPath"] />
	</cffunction>
	
	
	<!--- setJarPath() --->
	<cffunction name="setJarPath" access="public" output="no" returntype="any">
		<cfargument name="path" type="string" required="yes" />
		<cfset variables.Instance["jarPath"] = arguments.path />
	</cffunction>
	
	
	<!--- getClass() --->
	<cffunction name="getClass" access="public" output="no" returntype="string">
		<cfreturn variables.Instance["class"] />
	</cffunction>
	
	
	<!--- setClass() --->
	<cffunction name="setClass" access="public" output="no" returntype="any">
		<cfargument name="class" type="string" required="yes" />
		<cfset variables.Instance["class"] = arguments.class />
	</cffunction>
	
	
	<!--- getCompressor() --->
	<cffunction name="getCompressor" access="public" output="no" returntype="any">
		<cfreturn variables.Instance["compressor"] />
	</cffunction>
	
	
	<!--- setCompressor() --->
	<cffunction name="setCompressor" access="public" output="no" returntype="any">
		<cfargument name="compressor" type="any" required="yes" />
		<cfset variables.Instance["compressor"] = arguments.compressor />
	</cffunction>
	
	
	<!--- getJStringReader() --->
	<cffunction name="getJStringReader" access="private" output="no" returntype="any">
		<cfreturn variables.Instance["jStringReader"] />
	</cffunction>
	
	
	<!--- setJStringReader() --->
	<cffunction name="setJStringReader" access="private" output="no" returntype="any">
		<cfargument name="jStringReader" type="any" required="yes" />
		<cfset variables.Instance["jStringReader"] = arguments.jStringReader />
	</cffunction>
	
	
	<!--- getJStringWriter() --->
	<cffunction name="getJStringWriter" access="private" output="no" returntype="any">
		<cfreturn variables.Instance["jStringWriter"] />
	</cffunction>
	
	
	<!--- setJStringWriter() --->
	<cffunction name="setJStringWriter" access="private" output="no" returntype="any">
		<cfargument name="jStringWriter" type="any" required="yes" />
		<cfset variables.Instance["jStringWriter"] = arguments.jStringWriter />
	</cffunction>
	
	
	<!--- getJOutputStream() --->
	<cffunction name="getJOutputStream" access="private" output="no" returntype="any">
		<cfreturn variables.Instance["jOutputStream"] />
	</cffunction>
	
	
	<!--- setJOutputStream() --->
	<cffunction name="setJOutputStream" access="private" output="no" returntype="any">
		<cfargument name="jOutputStream" type="any" required="yes" />
		<cfset variables.Instance["jOutputStream"] = arguments.jOutputStream />
	</cffunction>

	
</cfcomponent>