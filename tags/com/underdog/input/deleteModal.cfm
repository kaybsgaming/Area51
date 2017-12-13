<cfimport prefix="input" taglib="/tags/com/underdog/input">
<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
	<cfparam name="attributes.disabled" default="0" >
<!-- Button triggers Delete modal -->
<a class="btn btn-u btn-u-red<cfif attributes.disabled> disabled</cfif>" <cfif not(attributes.disabled)>data-toggle="modal"  data-target="#deleteModal"</cfif>>Delete</a>
<cfif not(attributes.disabled)>
<cfsavecontent variable="tempModal" >
	<!-- Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      
	  <cfoutput>
      	<form action="/?controller=#request.entity#&do=delete" method="post" class="sky-form">
	  <header>
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-close"></i></button>
        <i class="icon-shield"></i> Are you sure?
      </header>
	      <fieldset>
	        	<input:hidden name="id" value="#request.o.getID()#"/>
				<input:checkbox name="confirm" value="true" label="Yes, I want to delete this content from the Database"/>
	      <fieldset>
	      <footer>
				<button type="submit" class="btn btn-u btn-u-red">Delete</button>
		   		<button class="btn btn-u btn-u-default" data-dismiss="modal">Cancel</a>
			</footer>
		   </form>
      </cfoutput>
    </div>
  </div>
</div>
</cfsavecontent>
<cfset arrayAppend(request.modals,tempModal)>
</cfif>
</cfcase> 
<cfdefaultcase></cfdefaultcase>	
</cfswitch>
