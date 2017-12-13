<cfparam name="attributes.label" default="Submit" >
<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
<button type="submit" class="btn-u"><cfoutput>#attributes.label#</cfoutput></button>

</cfcase> 
<cfdefaultcase></cfdefaultcase>	
</cfswitch>

