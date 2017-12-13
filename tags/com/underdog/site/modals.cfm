<cfif thistag.executionMode is "start">
<!---if we don't have the modals array in the request scope, create it (this should never happen) --->
<cfif not(structKeyExists(request,"modals"))>
	<cfset request.modals=[]>
</cfif>
<!---Loop over the request.modals array and output them --->
	<cfoutput>
		<cfloop array="#request.modals#" index="i">
#i#
		</cfloop>
	</cfoutput>
</cfif>