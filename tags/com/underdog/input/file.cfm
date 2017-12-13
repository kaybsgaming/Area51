<cfparam name="attributes.required" type="boolean" default="false">
<cfparam name="attributes.readonly" type="boolean" default="false">
<cfparam name="attributes.helper" type="string" default="">
<cfset thisID = attributes.name & createUUID()>

<cfswitch expression="#thistag.executionMode#" >
<cfcase value="start">
<cfoutput>
<label class="label">#attributes.label# <cfif len(attributes.helper)><small> - #attributes.helper#</small></cfif><cfif structKeyExists(attributes,"currentFile") AND len(attributes.currentFile)> <small>[<a href="#attributes.currentFile#">Link</a>]</small></cfif></label>
<label for="#thisID#" class="input input-file">
    <div class="button"><input name="#attributes.name#" type="file" id="#thisID#" onchange="this.parentNode.nextSibling.value = this.value" required="#attributes.required#">Browse</div><input type="text" readonly="#attributes.readonly#" required="#attributes.required#">
</label>
</cfoutput>
</cfcase>
</cfswitch>
