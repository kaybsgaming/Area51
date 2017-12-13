<cfparam name="attributes.disabled" default="false" >
<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
	 <cfoutput><label class="checkbox"><input type="checkbox" <cfif attributes.disabled>disabled</cfif> name="#attributes.name#" value="#attributes.value#" <cfif structKeyExists(attributes, "checked") AND attributes.checked>checked</cfif> <cfif structKeyExists(attributes, "required")>required="#attributes.required#"</cfif>/><i></i> #attributes.label# <cfif structKeyExists(attributes,"helper")><small> - <cfoutput>#attributes.helper#</cfoutput></small></cfif></label></cfoutput>
	<!---
		<section>
                            <label class="label">Columned checkboxes</label>
                            <div class="row">
                                <div class="col col-4">
                                    <label class="checkbox"><input type="checkbox" name="checkbox" checked=""><i></i>Alexandra</label>
                                    <label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Alice</label>
                                    <label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Anastasia</label>
                                </div>
                            </div>
                        </section>
		 --->
</cfcase> 
<cfdefaultcase></cfdefaultcase>	
</cfswitch>