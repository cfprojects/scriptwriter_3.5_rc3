<cfcomponent displayname="AsualLessEngine" extends="org.mgersting.scriptwriter.core.CompilerBase" output="no">
	
	
	<cfset variables.Instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="any">
		<cfscript>
			setJarPath(ExpandPath("/org/mgersting/scriptwriter/lib/lesscss-engine-1.1.4.jar"));
			setClass("com.asual.lesscss.LessEngine");
			return this;
		</cfscript>
	</cffunction>
	
	
	<!--- compile() --->
	<cffunction name="compile" access="public" output="no" returntype="string">
		<cfargument name="source" type="string" required="yes" />
		<cfreturn getEngine().compile(arguments.source) />
	</cffunction>

	
</cfcomponent>