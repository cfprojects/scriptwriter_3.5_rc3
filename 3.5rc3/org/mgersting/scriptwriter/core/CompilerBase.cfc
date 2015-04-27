<cfcomponent displayname="CompilerBase" output="no" hint="Abstract class for Java-based file processors. Provides utilty methods.">
	
	
	<cfproperty name="engine" type="any" />
	<cfproperty name="jarPath" type="any" />
	<cfproperty name="class" type="any" />
	
	<cfset variables.Instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfreturn this />
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
	
	
	<!--- getEngine() --->
	<cffunction name="getEngine" access="public" output="no" returntype="any">
		<cfreturn variables.Instance["engine"] />
	</cffunction>
	
	
	<!--- setEngine() --->
	<cffunction name="setEngine" access="public" output="no" returntype="any">
		<cfargument name="engine" type="any" required="yes" />
		<cfset variables.Instance["engine"] = arguments.engine />
	</cffunction>
	
	
</cfcomponent>