<cfparam name="attributes.required" type="boolean" default="false">
<cfparam name="attributes.required" type="boolean" default="false">
<cfparam name="attributes.helper" type="string" default="">
<cfparam name="attributes.value" type="string" default="">
<cfparam name="attributes.id" type="string" default="#attributes.name##createUUID()#">

<cfswitch expression="#thistag.executionMode#" >
<cfcase value="start">

	
<!---form item label --->
	<cfoutput><label for="#attributes.id#" class="label"><cfif structKeyExists(attributes,"label")>#attributes.label#<cfelse>#attributes.name#</cfif><cfif attributes.required>*</cfif><cfif len(attributes.helper)><small> - #attributes.helper#</small></cfif></cfoutput>
	
						<cfoutput><textarea class="ckeditor" id="#attributes.id#" name="#attributes.name#" <cfif structKeyExists(attributes, "rows")>rows="#val(attributes.rows)#"</cfif>>#attributes.value#</cfoutput></cfcase>
<cfdefaultcase></textarea></label>
					</cfdefaultcase> 
</cfswitch>
<!---

<div class="widget-content nopadding">
					<div class="control-group">
						

							<cfoutput>
								<textarea class="ckeditor" name="content">
									
								</textarea>
							</cfoutput>

					</div>

					<!--- form contents --->
				</div>

--->


















									
								