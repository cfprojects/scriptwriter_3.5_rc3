<cfcomponent displayname="Factory" output="no" hint="Factory bean for the ScriptWriter system.">
	
	
	<cfproperty name="JavaScriptCompressor" type="any" />
	<cfproperty name="CssCompressor" type="any" />
	<cfproperty name="REQUESTS" type="struct" />
	<cfproperty name="TIMESTAMPS" type="array" />
	<cfproperty name="dataTimeout" type="numeric" />
	<cfproperty name="errorMode" type="string" />
	<cfset variables.instance = {} />
	
	
	<!--- init() --->
	<cffunction name="init" access="public" returntype="org.mgersting.scriptwriter.core.Factory">
		<cfargument name="writeMode" type="string" required="no" default="lazy" />
		<cfargument name="javaScriptCompressor" type="string" required="no" default="org.mgersting.scriptwriter.core.JSMin" />
		<cfargument name="cssCompressor" type="string" required="no" default="org.mgersting.scriptwriter.core.YUICssCompressor" />
		<cfargument name="lessEngine" type="string" required="no" default="org.mgersting.scriptwriter.core.AsualLessEngine" />
		<cfargument name="dataTimeout" type="numeric" required="no" default="60" />
		<cfargument name="errorMode" type="string" required="no" default="silent" />
		<cfscript>
			
			// Initailize the structure that holds individual request, region, and group data.
			initRequestStruct();
			initTimestamps();
			
			// Compressors are optional.  Object checks are done later.
			setWriteMode(arguments.writeMode);
			setJavaScriptCompressor(CreateObject("component",arguments.javaScriptCompressor).init());
			setCssCompressor(CreateObject("component",arguments.cssCompressor).init());
			setLessEngine(CreateObject("component",arguments.lessEngine).init());
			setDataTimeout(arguments.dataTimeout);
			setErrorMode(arguments.errorMode);
			
			injectJavaEngines();
			
		</cfscript>
		<cfreturn this>
	</cffunction>
	
	
	<!--- injectJavaEngines() --->
	<cffunction name="injectJavaEngines" access="private" output="no" returntype="any">
		<cfscript>
			setJavaLoader(CreateObject("component","org.mgersting.scriptwriter.lib.javaloader.JavaLoader").init(getCompressorJarPaths()));
			getJavaScriptCompressor().setCompressor(getJavaLoader().create(getJavaScriptCompressor().getClass()));
			getCssCompressor().setCompressor(getJavaLoader().create(getCssCompressor().getClass()));
			getLessEngine().setEngine(getJavaLoader().create(getLessEngine().getClass()));
		</cfscript>
	</cffunction>
	
	
	<!--- getCompressorJarPaths() --->
	<cffunction name="getCompressorJarPaths" access="private" output="no" returntype="array">
		<cfscript>
			var local = {};
			local.jarPaths = ArrayNew(1);
			ArrayAppend(local.jarPaths, getJavaScriptCompressor().getJarPath());
			ArrayAppend(local.jarPaths, getCssCompressor().getJarPath());
			ArrayAppend(local.jarPaths, getLessEngine().getJarPath());
			return local.jarPaths;
		</cfscript>
	</cffunction>
	
	
	<!--- initRequestStruct() --->
	<cffunction name="initRequestStruct" access="private" returntype="any">
		<cfset variables.instance["REQUESTS"] = StructNew() />
	</cffunction>
	
	
	<!--- initTimestamps() --->
	<cffunction name="initTimestamps" access="private" returntype="any">
		<cfset variables.instance["TIMESTAMPS"] = ArrayNew(1) />
	</cffunction>
	
	
	<!--- getJavaLoader() --->
	<cffunction name="getJavaLoader" access="private" returntype="any">
		<cfreturn variables.instance["javaLoader"] />
	</cffunction>
	
	
	<!--- setJavaLoader() --->
	<cffunction name="setJavaLoader" access="private" returntype="any">
		<cfargument name="loader" type="any" required="yes" />
		<cfset variables.instance["javaLoader"] = arguments.loader />
	</cffunction>
	
	
	<!--- getJavaScriptCompressor() --->
	<cffunction name="getJavaScriptCompressor" access="private" returntype="any" hint="Returns the JavaScript Compressor object.">
		<cfreturn variables.instance["javaScriptCompressor"] />
	</cffunction>
	
	
	<!--- setJavaScriptCompressor() --->
	<cffunction name="setJavaScriptCompressor" access="private" returntype="any" hint="Sets the JavaScript Compressor object.">
		<cfargument name="oCompressor" type="any" required="true" />
		<cfset variables.instance["javaScriptCompressor"] = arguments.oCompressor />
	</cffunction>
	
	
	<!--- getCssCompressor() --->
	<cffunction name="getCssCompressor" access="private" returntype="any" hint="Returns the CSS Compressor object.">
		<cfscript>
			if (NOT IsSimpleValue(variables.instance["cssCompressor"])) {
				return variables.instance["cssCompressor"];	
			}
			else if (variables.instance["cssCompressor"] NEQ "") {
				setCssCompressor(CreateObject("component",variables.instance["cssCompressor"]).init());	
				return getCssCompressor();
			}
		</cfscript>
	</cffunction>
	
	
	<!--- setCssCompressor() --->
	<cffunction name="setCssCompressor" access="private" returntype="any" hint="Sets the CSS Compressor object.">
		<cfargument name="compressor" type="any" required="true" />
		<cfset variables.instance["cssCompressor"] = arguments.compressor />
	</cffunction>
	
	
	<!--- getLessEngine() --->
	<cffunction name="getLessEngine" access="private" returntype="any" hint="Returns the LESS engine object.">
		<cfscript>
			if (NOT IsSimpleValue(variables.instance["lessEngine"])) {
				return variables.instance["lessEngine"];	
			}
			else if (variables.instance["lessEngine"] NEQ "") {
				setLessEngine(CreateObject("component",variables.instance["lessEngine"]).init());	
				return getLessEngine();
			}
		</cfscript>
	</cffunction>
	
	
	<!--- setLessEngine() --->
	<cffunction name="setLessEngine" access="private" returntype="any" hint="Sets the LESS engine object.">
		<cfargument name="engine" type="any" required="true" />
		<cfset variables.instance["lessEngine"] = arguments.engine />
	</cffunction>
	
	
	<!--- getWriteMode() --->
	<cffunction name="getWriteMode" access="private" returntype="any" hint="Return the Factory object write mode.">
		<cfreturn variables.instance["WriteMode"] />
	</cffunction>
	
	
	<!--- setWriteMode() --->
	<cffunction name="setWriteMode" access="private" returntype="any" hint="Sets the Factory object write mode (to 'lazy' or 'eager')">
		<cfargument name="writeMode" type="string" required="true" />

		<cfset variables.instance["WriteMode"] = arguments.writeMode />
	</cffunction>
	
	
	<!--- getRequestStruct() --->
	<cffunction name="getRequestStruct" access="public" output="no" returntype="struct">
		<cfreturn variables.instance["REQUESTS"] />
	</cffunction>
	
	
	<!--- setRequestStruct() --->
	<cffunction name="setRequestStruct" access="public" output="no" returntype="any">
		<cfargument name="struct" type="struct" required="yes" />
		<cfset variables.instance["REQUESTS"] = arguments.struct />
	</cffunction>
	
	
	<!--- getTimestamps() --->
	<cffunction name="getTimestamps" access="public" output="no" returntype="array">
		<cfreturn variables.instance["TIMESTAMPS"] />
	</cffunction>
	
	
	<!--- getDataTimeOut() --->
	<cffunction name="getDataTimeOut" access="private" returntype="any" hint="Return the Factory object write mode.">
		<cfreturn variables.instance["dataTimeOut"] />
	</cffunction>
	
	
	<!--- setDataTimeOut() --->
	<cffunction name="setDataTimeOut" access="private" returntype="any" hint="Sets the Factory object write mode (to 'lazy' or 'eager')">
		<cfargument name="dataTimeOut" type="string" required="true" />
		<cfset variables.instance["dataTimeOut"] = arguments.dataTimeOut />
	</cffunction>
	
	
	<!--- getErrorMode() --->
	<cffunction name="getErrorMode" access="private" returntype="any" hint="">
		<cfreturn variables.instance["errorMode"] />
	</cffunction>
	
	
	<!--- setOutputMethodErrorMode() --->
	<cffunction name="setErrorMode" access="private" returntype="any" hint="">
		<cfargument name="mode" type="string" required="true" />
		<cfset variables.instance["errorMode"] = arguments.mode />
	</cffunction>

	
	<!--- openRequest() --->
	<cffunction name="openRequest" access="public" output="no" returntype="any" hint="Take a UUID as an argument. Uses this in tandem with createPerRequestTemplateStruct() to generate an empty structure in which to hold data for that request.">
		<cfargument name="request" type="string" required="yes" />
		<cfscript>
			addEmptyTemplateToMasterRequestStruct(arguments.request);
			addRequestTimestamp(arguments.request);
		</cfscript>
	</cffunction>
	
	
	<!--- createPerRequestTemplateStruct() --->
	<cffunction name="createPerRequestTemplateStruct" access="private" output="no" returntype="struct" hint="Creates the basic structure used to hold per-request style and script data.">
		<cfscript>
			var local = {};
			local.stRequestTemplate = StructNew();
			local.stRequestTemplate["SCRIPT"] = StructNew();
			local.stRequestTemplate["STYLE"] = StructNew();
			local.stRequestTemplate["CUSTOM"] = StructNew();
			return local.stRequestTemplate;
		</cfscript>
	</cffunction>
	
	
	<!--- addEmptyTemplateToMasterRequestStruct() --->
	<cffunction name="addEmptyTemplateToMasterRequestStruct" access="private" output="no" returntype="void" hint="">
		<cfargument name="requestID" type="string" required="yes" />
		<cfset StructInsert(getRequestStruct(),arguments.requestID,createPerRequestTemplateStruct()) />
	</cffunction>
	
	
	<!--- addRequestTimestamp() --->
	<cffunction name="addRequestTimestamp" access="private" output="no" returntype="void" hint="Creates a timestamp for the given request ID.">
		<cfargument name="requestID" type="string" required="yes" />
		<cfset ArrayAppend(getTimestamps(),"#Now()#,#arguments.requestID#") />
	</cffunction>

	
	<!--- closeRequest() --->
	<cffunction name="closeRequest" access="public" output="no" returntype="any" hint="Removes the structure related to a request ID from ScriptWriter's memory.">
		<cfargument name="request" type="string" required="yes" />
		<cfscript>
			removeIndividualRequestFromMasterRequestStruct(arguments.request);
			cleanupStrandedRequestData();
		</cfscript>
	</cffunction>
	
	
	<!--- removeIndividualRequestFromMasterRequestStruct() --->
	<cffunction name="removeIndividualRequestFromMasterRequestStruct" access="private" output="no" returntype="void" hint="">
		<cfargument name="requestID" type="string" required="yes" />
		<cfscript>
			StructDelete(getRequestStruct(),arguments.requestID);
		</cfscript>
	</cffunction>
	
	
	<!--- cleanupStrandedRequestData() --->
	<cffunction name="cleanupStrandedRequestData" access="private" output="no" returntype="any">
		<cfset var local = {} />
		<cfset local.arTimestamps = getTimestamps() />
		<cfif (NOT ArrayIsEmpty(local.arTimestamps))>
			<cfset local.sOldestTimestamp = local.arTimestamps[1] />
			<cfset local.sTimestampTime = ListGetAt(local.sOldestTimestamp,1) />
			<cfset local.sTimestampRequestID = ListGetAt(local.sOldestTimestamp,2) />
			<cfif (DateDiff("s",local.sTimestampTime,Now()) GTE getDataTimeout())>
				<cfset ArrayDeleteAt(getTimestamps(),1) />
				<cfset closeRequest(local.sTimestampRequestID) />
			</cfif>
		</cfif>
	</cffunction>
	
	
	<!--- add() --->
	<cffunction name="add" access="public" output="no" returntype="any">
		<cfargument name="request" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="path" type="string" required="no" default="" />
		<cfargument name="paths" type="array" required="no" default="#ArrayNew(1)#" />
		<cfargument name="src" type="string" required="no" default="" />
		<cfargument name="region" type="string" required="yes" />
		<cfargument name="group" type="string" required="no" default="DEFAULT" />
		<cfargument name="minify" type="boolean" required="no" default="false" />
		<cfargument name="outputPath" type="string" required="no" default="" />
		<cfargument name="writeMode" type="string" required="no" default="" />
		<cfargument name="keyDelimiter" type="string" required="no" default="$" />
		<cfargument name="keys" type="struct" required="no" default="#StructNew()#" />
		<cfargument name="media" type="string" required="no" default="screen" />
		
		<cfset var local = {} />
		<cfscript>
			
			// As a default, set the write mode equal to what the Factory
			// has been set to, but then check that against the argument coming in.
			// If the argument differs from the factory-set mode, use the argument.
			// This allows the user to set a global factory default but change the behavior
			// on an item-by-item basis.
			local.writeMode = arguments.writeMode;
			if (local.writeMode EQ "") {
				local.writeMode = getWriteMode();	
			}
			
			// Prepare the structs
			prepRegion(arguments.request, UCase(arguments.type), UCase(arguments.region));
			prepGroup(arguments.request, UCase(arguments.type), UCase(arguments.region), UCase(arguments.group));
			
			if (ArrayIsEmpty(arguments.paths)) {
				ArrayAppend(arguments.paths, arguments.path);
			}
			
			for (local.i = 1; local.i LTE ArrayLen(arguments.paths); local.i++) {
					
				// Create an object of the correct type
				local.oExternalElement = createElementObject(
					elementType = arguments.type,
					path = arguments.paths[local.i],
					source = arguments.src,
					minify = arguments.minify,
					outputPath = arguments.outputPath,
					mode = local.writeMode,
					keyDelimiter = arguments.keyDelimiter,
					keys = arguments.keys,
					media = arguments.media
				);
				
				// Add the element
				addItem(arguments.request, UCase(arguments.type), UCase(arguments.region), UCase(arguments.group), local.oExternalElement);
				
			}
			
		</cfscript>
	</cffunction>
	
	
	<!--- clear() --->
	<cffunction name="clear" access="public" output="no" returntype="any">
		<cfargument name="request" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="region" type="string" required="no" default="" />
		<cfargument name="group" type="string" required="no" default="" />
		
		<cfif ((arguments.group EQ "") AND (arguments.region EQ ""))>
			<cfset clearType(requestID=arguments.request, type=arguments.type) />
		<cfelseif ((arguments.group EQ "") AND (arguments.region NEQ ""))>
			<cfset clearRegion(requestID=arguments.request, type=arguments.type, regionName=arguments.region) />
		<cfelseif ((arguments.group NEQ "") AND (arguments.region NEQ ""))>
			<cfset clearGroup(requestID=arguments.request, type=arguments.type, regionName=arguments.region, groupName=arguments.group) />
		</cfif>
		
	</cffunction>


	<!--- clearType() --->
	<cffunction name="clearType" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset StructClear(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]) />
		<cfset setRequestStruct(local.stRequests) />
	</cffunction>     
	
	
	<!--- createElementObject() --->
	<cffunction name="createElementObject" access="private" output="no" returntype="any">
		<cfargument name="elementType" type="string" required="yes" />
		<cfargument name="path" type="string" required="yes" />
		<cfargument name="source" type="string" required="no" default="" />
		<cfargument name="minify" type="boolean" required="no" default="false" />
		<cfargument name="outputPath" type="string" required="no" default="" />
		<cfargument name="mode" type="string" required="no" default="" />
		<cfargument name="keyDelimiter" type="string" required="no" default="$" />
		<cfargument name="keys" type="struct" required="no" default="#StructNew()#" />
		<cfargument name="media" type="string" required="no" default="" />
		
		<cfset var local = {} />
		<cfscript>
			if (arguments.elementType EQ "script") {
				local.sElementComponentType = "org.mgersting.scriptwriter.core.Script";
				local.oElementCompressor = getJavaScriptCompressor();
				local.oElementEngine = "";
			}
			else if (arguments.elementType EQ "style") {
				local.sElementComponentType = "org.mgersting.scriptwriter.core.Style";
				local.oElementCompressor = getCssCompressor();
				if (Right(arguments.path,4) EQ "less") {
					local.oElementEngine = getLessEngine();
				}
				else {
					local.oElementEngine = "";
				}
			}
			else if (arguments.elementType EQ "custom") {
				local.sElementComponentType = "org.mgersting.scriptwriter.core.CustomElement";
				local.oElementCompressor = "";
				local.oElementEngine = "";
			}
			
			local.oObj = CreateObject("component","#local.sElementComponentType#").init(
				path = arguments.path,
				src = arguments.source,
				minify = arguments.minify,
				outputPath = arguments.outputPath,
				compressor = local.oElementCompressor,
				mode = arguments.mode,
				keyDelimiter = arguments.keyDelimiter,
				keys = arguments.keys,
				media = arguments.media,
				engine = local.oElementEngine
			);
			
			return local.oObj;			
		</cfscript>
	</cffunction>
	
	
	<!--- getRegionOrGroup() --->
	<cffunction name="getRegionOrGroup" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfargument name="errorMode" type="string" required="yes" />
		<cfscript>
		
			// Look to see if we're even trying to pull a specific group
			if (arguments.groupName NEQ "") {
				// See if it exists
				if (getGroupExists(arguments.requestID,arguments.type,arguments.regionName,arguments.groupName)) {
					return getGroup(arguments.requestID,arguments.type,arguments.regionName,arguments.groupName);
				}
				else {
					if (arguments.errorMode EQ "error") {
						throw("Not found: #arguments.type# > #arguments.regionName# > #arguments.groupName#");	
					}
					else if (arguments.errorMode EQ "comment") {
						return "<!-- Not found: #arguments.type# > #arguments.regionName# > #arguments.groupName# -->";
					}
				}
			}
			else {
				if (arguments.regionName NEQ "") {
					if (getRegionExists(arguments.requestID,arguments.type,arguments.regionName)) {
						return getRegion(arguments.requestID,arguments.type,arguments.regionName);	
					}
					else {
						if (arguments.errorMode EQ "error") {
							throw("Not found: #arguments.type# > #arguments.regionName#");	
						}
						else if (arguments.errorMode EQ "comment") {
							return "<!-- Not found: #arguments.type# > #arguments.regionName# -->";
						}
					}
				}
			}
		</cfscript>
		

	</cffunction>
	
	<!--- prepRegion() --->
	<cffunction name="prepRegion" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		
		<cfscript>
			// Look to see if the region exists within the request and data type. If not,
			// go ahead and create the region.
			if (NOT getRegionExists(arguments.requestID,arguments.type,arguments.regionName)) {
				createRegion(arguments.requestID,arguments.type,arguments.regionName);
			}
		</cfscript>
		
	</cffunction>
	
	
	<!--- getRegionExists() --->
	<cffunction name="getRegionExists" access="private" output="no" returntype="boolean">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		
		<cfset var local = {} />
		<cfscript>
			local.stRequests = getRequestStruct();
			return StructKeyExists(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"],arguments.regionName);
		</cfscript>

	</cffunction>
	
	
	<!--- getRegion() --->
	<cffunction name="getRegion" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cftry>
			<cfreturn local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#UCase(arguments.regionName)#"] />
			<cfcatch type="any">
				<cfthrow message="ScriptWriter encounted a problem trying to access the region '#arguments.regionName#'.  This is usually because you are trying to output from a region (or type) that no item has been added to and therefore does not exist.  Double check the name of the region you are trying to output." />
			</cfcatch>
		</cftry>
	</cffunction>
	
	
	<!--- createRegion() --->
	<cffunction name="createRegion" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		
		<cfset var local = {} />
		<cfset local.stSubRegion = StructNew() />
		<cfset local.stSubRegion["DEFAULT"] = ArrayNew(1) />
		<cfset local.stRequest = getRequestStruct() />
		<cfset StructInsert(local.stRequest["#arguments.requestID#"]["#UCase(arguments.type)#"],arguments.regionName,local.stSubRegion) />
	</cffunction>
	
	
	<!--- clearRegion() --->
	<cffunction name="clearRegion" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset StructClear(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#arguments.regionName#"]) />
		<cfset setRequestStruct(local.stRequests) />
	</cffunction>
	
	
	<!--- addItem() --->
	<cffunction name="addItem" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfargument name="oItem" type="any" required="yes" />		
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset ArrayAppend(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#arguments.regionName#"]["#arguments.groupName#"],arguments.oItem) />
		<cfset setRequestStruct(local.stRequests) />
	</cffunction>
	
	
	<!--- prepGroup() --->
	<cffunction name="prepGroup" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfif (NOT getGroupExists(arguments.requestID,arguments.type,arguments.regionName,arguments.groupName))>
			<cfset createGroup(arguments.requestID,arguments.type,arguments.regionName,arguments.groupName) />
		</cfif>
	</cffunction>
	
	
	<!--- getGroupExists() --->
	<cffunction name="getGroupExists" access="private" output="no" returntype="boolean">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfreturn StructKeyExists(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#arguments.regionName#"],arguments.groupName) />
	</cffunction>
	
	
	<!--- getGroup() --->
	<cffunction name="getGroup" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cftry>
			<cfreturn local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#UCase(arguments.regionName)#"]["#UCase(arguments.groupName)#"] />
			<cfcatch type="any">
				<cfthrow message="ScriptWriter encounted a problem trying to access the group '#arguments.type# > #arguments.regionName# > #arguments.groupName#'.  This is usually because you are trying to output from a type/region/group that no item has been added to and therefore does not exist.  Double check the name of the type/region/group you are trying to output." />
			</cfcatch>
		</cftry>
	</cffunction>
	
	
	<!--- createGroup() --->
	<cffunction name="createGroup" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset StructInsert(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#arguments.regionName#"],UCase(arguments.groupName),ArrayNew(1)) />
		<cfset setRequestStruct(local.stRequests) />
	</cffunction>
	
	
	<!--- clearGroup() --->
	<cffunction name="clearGroup" access="private" output="no" returntype="any">
		<cfargument name="requestID" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="regionName" type="string" required="yes" />
		<cfargument name="groupName" type="string" required="yes" />
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset ArrayClear(local.stRequests["#arguments.requestID#"]["#UCase(arguments.type)#"]["#arguments.regionName#"]["#arguments.groupName#"]) />
		<cfset setRequestStruct(local.stRequests) />
	</cffunction>
	
	
	<!--- combine() --->
	<cffunction name="combine" access="public" output="no" returntype="any">
		<cfargument name="request" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="outputPath" type="string" required="yes" />
		<cfargument name="region" type="string" required="yes" />
		<cfargument name="group" type="string" required="no" default="DEFAULT" />
		<cfargument name="media" type="string" required="no" default="screen" />
		
		<cfset var local = {} />
		<cfset local.stRequests = getRequestStruct() />
		<cfset local.data = getRegionOrGroup(requestID=arguments.request, type=arguments.type, regionName=arguments.region, groupName=arguments.group, errorMode=getErrorMode())/>
		<cfif (NOT IsNull(local.data))>
			
			<cfset local.arFiles = local.stRequests["#arguments.request#"]["#UCase(arguments.type)#"]["#arguments.region#"]["#arguments.group#"] />
			<cfif (getWriteMode() EQ "eager") OR (NOT FileExists(ExpandPath(arguments.outputPath)))>
				<cfset local.sCombinationSource = "" />
				<cfloop from="1" to="#ArrayLen(local.arFiles)#" index="i">
					<cfset local.sCombinationSource &= local.arFiles[i].getPreferredSource() />
				</cfloop>
				<cfset FileWrite(ExpandPath(arguments.outputPath),local.sCombinationSource) />
			</cfif>
			
			<cfset clearGroup(arguments.request,arguments.type,arguments.region,arguments.group) />
			<cfset local.oItem = createElementObject(elementType=arguments.type, path=arguments.outputPath, media=arguments.media) />
			<cfset addItem(arguments.request,arguments.type,arguments.region,arguments.group,local.oItem) />
			
		</cfif>
		
	</cffunction>
	
	
	<!--- output() --->
	<cffunction name="output" access="public" output="no" returntype="any">
		<cfargument name="request" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
		<cfargument name="region" type="string" required="yes" />
		<cfargument name="group" type="string" required="no" default="" />
		
		<cfset var local = {} />
		<cfset local.sOutputString = "" />
		<cftry>
			
			<cfset local.data = getRegionOrGroup(requestID=arguments.request, type=arguments.type, regionName=arguments.region, groupName=arguments.group, errorMode=getErrorMode()) />
			<cfif (NOT IsNull(local.data))>
			
				
				<cfif (IsSimpleValue(local.data))>
					<cfreturn local.data />
				<cfelseif (IsArray(local.data))>
					<cfset local.stRegion = StructNew() />
					<cfset local.stRegion.holder = local.data />
				<cfelse>
					<cfset local.stRegion = local.data />
				</cfif>
				
				<cfset local.sRegionKeyList = StructKeyList(local.stRegion) />
				<cfset local.sNewLineFormatters = chr(10) & chr(9)>
				
				<cfif (NOT StructIsEmpty(local.stRegion))>
					<!--- Loop through region groups --->
					<cfloop from="1" to="#StructCount(local.stRegion)#" index="i">
						<!--- Loop through group scripts --->
						<cfset local.arCurrentGroupScripts = local.stRegion["#ListGetAt(local.sRegionKeyList,i)#"] />
						<cfloop from="1" to="#ArrayLen(local.arCurrentGroupScripts)#" index="x">
							<cfset local.sOutputString = local.sOutputString & (local.arCurrentGroupScripts[x].getOutputFormat() & local.sNewLineFormatters) />
						</cfloop>
					</cfloop>
				</cfif>
				
			</cfif>	
			
			<cfcatch type="any">
				<!--- There was a problem. Error out. --->
				<cfrethrow />
			</cfcatch>
			
		</cftry>
		
		<cfreturn local.sOutputString />
	</cffunction>
	
	
	<!--- dump() --->
	<cffunction name="dump" access="public" returntype="any" output="no">
		<cfscript>
			stDump = StructNew();
			stDump.Object = this;
			stDump.InstanceVariables = Instance;
		</cfscript>
		<cfdump var="#stDump#">
		<cfabort>
	</cffunction>
	

</cfcomponent>