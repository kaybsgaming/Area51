<cfif structKeyExists(request,"jScript")>
	<cfif (isArray(request.JScript) AND ArrayLen(request.JScript))>
		<cfloop array="#request.JScript#" index="i">
			<cfoutput>#i#</cfoutput>
		</cfloop>
	</cfif>
</cfif>
<cfset request.JScript=[]>