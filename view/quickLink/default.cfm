<cfimport prefix="ud" taglib="/tags/com/underdog/site">
<ud:header>
<ud:breadcrumbs/>

<div id="content" class="container-fluid">



						<cfoutput><a href="/?controller=#request.entity#&do=form" class="btn btn-default"><i class="icon-plus"></i> Add New</a> </cfoutput>

					<cfif arrayLen(request.listArray)>
  						<table class="table table-striped">
					    	<thead>
					        	<tr>
					          		<th>#</th>
					          		<th>Title</th>
									<th>Date Created</th>
									<th>Last Modified</th>
					        	</tr>
					      	</thead>
					      	<tbody>
					       	<cfoutput>
								<cfloop array="#request.listArray#" index="i" >
									<tr class="gradeX">
										<td>#i.getid()#</td>
										<td><a href="/?controller=#request.entity#&do=form&id=#i.getid()#"> #i.getTitle()#</a></td>
										<td>#lsdateformat(i.getDateCreated())# #lstimeformat(i.getDateCreated())#</td>
										<td>#lsdateformat(i.getDateModified())# #lstimeformat(i.getDateModified())#</td>
									</tr>
								</cfloop>
							</cfoutput>
      						</tbody>
    					</table>
					<cfelse>
					<br><br>
						<div class="alert alert-info">
      						<strong>No Content Found</strong> Please click the "Add New..." button above to create content.
    					</div>
					</cfif>	


</div>					
<ud:footer/>		