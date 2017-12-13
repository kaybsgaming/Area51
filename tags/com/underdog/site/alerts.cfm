<cfif thistag.executionMode is "start">
<cfset thistag.local={}>

<cfif isDefined("session") AND not(structKeyExists(session,"alerts"))>
	<cfset session.alerts=[]>
</cfif>
<cfif arrayLen(session.alerts)>
	<cfoutput>
	<script>

		<cfloop array="#session.alerts#" index="i">

				$.bootstrapGrowl("#i.title#<cfif len(trim(i.description))> - #i.description#</cfif>", {
				  ele: 'body', // which element to append to
				  type: '#i.type#', // (null, 'info', 'error', 'success')
				  offset: {from: 'top', amount: 88}, // 'top', or 'bottom'
				  align: 'center', // ('left', 'right', or 'center')
				  width: "600", // (integer, or 'auto')
				  delay: 2000,
				  allow_dismiss: true,
				  stackup_spacing: 5 // spacing between consecutively stacked growls.
				});

		</cfloop>
	</script>
	</cfoutput>

</cfif>

<!---
<div class="alert alert-#i.type# alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	<strong>#i.title#</strong> #i.description#
</div>
--->		
</cfif>