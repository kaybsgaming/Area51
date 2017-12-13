<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnYesNo&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="yesNoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Yes/No</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name" required="true"/>
	
	<div class="form-group">
	<label>Default Value</label>
	<select class="form-control" name="default">
		<option value="1" >Yes</option>
		<option value="0" >No</option>
	</select>
	</div>
	
	
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Save column</button>
      </div>
    </div>
  </div>
</div>
</form>
</cfif>