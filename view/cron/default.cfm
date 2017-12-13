<cfimport prefix="ud" taglib="/tags/com/underdog/site">
<ud:header>
<ud:breadcrumbs/>

    <div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
		<h2>Cron Status Report</h2>
			<div class="row">
				<div class="col-md-12">
					<cfloop array="#request.data#" index = "s">
						<h4>Source: <cfoutput>#s.server.name# <cfif structKeyExists(s.server,"error")> responded with "#s.server.results#"</cfif></cfoutput></h4>
						<cfif structKeyExists(s.server,"results") && not(structKeyExists(s.server,"error"))>
							<table class="table">
								<thead>
									<tr>
										<th>#</th>
										<th>Description</th>
										<th>Frequency</th>
										<th>Last Run<th>
									</tr>
								</thead>
								<tbody>
									<cfoutput>
									<cfloop array="#s.server.results#" index="c">
										<tr class="#c.status#">
											<td>#c.id#</td>
											<td>#c.description#</td>
											<td>#c.frequency#</td>
											<td>#request.util.ago(c.lastRun)# <cfif not(compareNoCase(c.status,"danger"))><small>Last run: #dateFormat(c.lastRun,"dd mmm yyyy")# #timeformat(c.lastRun, "HH:mm")#h (#c.ago# ago)</small></cfif></td>
										</tr>
									</cfloop>
									</cfoutput>
								</tbody>
							</table>
						</cfif>
					</cfloop>
				</div>
			</div>
		</div>
	</div>
</div>
<ud:footer>