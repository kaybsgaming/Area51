<cfparam name="attributes.href" default="" >
<cfparam name="attributes.onclick" default="" >
<cfparam name="attributes.label" default="Cancel" >
<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
<cfoutput><a class="btn btn-u btn-u-default" <cfif structKeyExists(attributes,"dismiss")>data-dismiss="modal"<cfelseif len(attributes.onclick)>onclick="#attributes.onclick#"<cfelse>href="#attributes.href#"</cfif>>#attributes.label#</a></cfoutput>
</cfcase> 
<cfdefaultcase></cfdefaultcase>	
</cfswitch>

