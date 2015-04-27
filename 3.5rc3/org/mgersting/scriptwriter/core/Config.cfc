<cfcomponent displayname="ScriptWriterConfig" accessors="true">

	<cfproperty name="writeMode" type="string" default="eager" />
	<cfproperty name="jsCompressorJarPath" type="string" default="scriptwriter/lib/jsmin.jar" />
	<cfproperty name="jsCompressorClass" type="string" default="" />
	<cfproperty name="cssCompressorJarPath" type="string" default="" />
	<cfproperty name="cssCompressorClass" type="string" default="" />
	<cfproperty name="lessEngineJarPath" type="string" default="" />
	<cfproperty name="lessEngineClass" type="string" default="" />
	<cfproperty name="dataTimeout" type="numeric" default="60" />
	<cfproperty name="errorMode" type="string" default="silent" />

</cfcomponent>