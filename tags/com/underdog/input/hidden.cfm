<cfparam name="attributes.value" type="string" default="">
<cfswitch expression="#thistag.executionMode#" >
<cfcase value="start">
	<cfset thisID = attributes.name & createUUID()>
	<cfoutput><input type="hidden" <cfif structKeyExists(attributes,"showID")> id="#thisID#"</cfif> name="#attributes.name#" value="#attributes.value#" /></cfoutput>
</cfcase>
<cfdefaultcase><cfset thistag.generatedcontent = ""></cfdefaultcase> 
</cfswitch>
