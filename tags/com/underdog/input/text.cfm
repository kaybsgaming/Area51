<cfparam name="attributes.value" type="string" default="">
<cfparam name="attributes.prepend" type="string" default="">
<cfparam name="attributes.append" type="string" default="">

<cfparam name="attributes.required" type="boolean" default="false">
<cfparam name="attributes.readonly" type="boolean" default="false">
<cfparam name="attributes.type" type="string" default="text">
<cfparam name="attributes.helper" type="string" default="">

<cfswitch expression="#thistag.executionMode#" >
<cfcase value="start">
<cfset thisID = attributes.name & createUUID()>
<section>

	<!---form item label --->
	<cfoutput><label for="#thisID#" class="label"><cfif structKeyExists(attributes,"label")>#attributes.label#<cfelse>#attributes.name#</cfif><cfif attributes.required>*</cfif><cfif len(attributes.helper)><small> - #attributes.helper#</small></cfif></label>
	
	
	<!---Actual text input field (putting in attributes if/when they exist) --->
	<label class="input"><cfif len(attributes.prepend)><i class="icon-prepend #attributes.prepend#"></i></cfif><!---Prefix Content ---><input type="#attributes.type#" <cfif attributes.readonly>readonly</cfif> <cfif structKeyExists(attributes, "placeholder")> placeholder="#attributes.placeholder#"</cfif> class="form-control" id="#thisID#" name="#attributes.name#" <cfif len(attributes.value)>value="#attributes.value#"</cfif> <cfif attributes.required>required="true"</cfif>/></label>
	<cfif len(attributes.append)><i class="#attributes.append#"></i></cfif><!---Suffix Content --->

	
		</cfoutput></section>
</cfcase>
<cfdefaultcase><cfset thistag.generatedcontent = ""></cfdefaultcase><!---Close out the content in the tag, otherwise it will end up being duplicated ---> 
</cfswitch>
<!---

 --->
