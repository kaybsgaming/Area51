<cfparam name="attributes.value" type="string" default="">
<cfparam name="attributes.default" type="string" default="">
<cfparam name="attributes.showDate" type="boolean" default="true">
<cfparam name="attributes.showTime" type="boolean" default="true">
<cfparam name="attributes.required" type="boolean" default="false">
<cfparam name="attributes.readonly" type="boolean" default="false">
<cfparam name="attributes.type" type="string" default="text">


<cfif attributes.defaultToNow AND not(len(attributes.default))>
	<cfset attributes.value=now()>		
</cfif>

<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
	<cfset thisID = attributes.name & createUUID()>
	<cfif attributes.showDate>
		<cfoutput>
		<div class="form-group ">
		<!---form item label --->
		<label for="#thisID#-date"><cfif structKeyExists(attributes,"label")>#attributes.label#<cfelse>#attributes.name#</cfif>(Date) <cfif attributes.required>*</cfif></label>
		
		
		
		<!---Actual text input field (putting in attributes if/when they exist) --->
		<input type="date" <cfif attributes.readonly>readonly</cfif> <cfif structKeyExists(attributes, "placeholder")> placeholder="#attributes.placeholder#"</cfif> class="form-control" id="#thisID#-date" name="#attributes.name#-date" <cfif len(attributes.value)>value="#dateFormat(attributes.value,"yyyy-mm-dd")#"</cfif> <cfif attributes.required>required="true"</cfif>/>
		</div>
		</cfoutput>

	</cfif>
	<cfif attributes.showDate>
		<cfoutput>
		<div class="form-group ">
		<!---form item label --->
		<label for="#thisID#-time"><cfif structKeyExists(attributes,"label")>#attributes.label#<cfelse>#attributes.name#</cfif> (Time)<cfif attributes.required>*</cfif></label>
		
		
		
		<!---Actual text input field (putting in attributes if/when they exist) --->
		<input type="time" <cfif attributes.readonly>readonly</cfif> <cfif structKeyExists(attributes, "placeholder")> placeholder="#attributes.placeholder#"</cfif> class="form-control" id="#thisID#-time" name="#attributes.name#-time" <cfif len(attributes.value)>value="#timeFormat(attributes.value,"HH:MM")#"</cfif> <cfif attributes.required>required="true"</cfif>/>
		</div>
		</cfoutput>
	</cfif>
</cfcase>
<cfdefaultcase>

</cfdefaultcase> 
</cfswitch>
