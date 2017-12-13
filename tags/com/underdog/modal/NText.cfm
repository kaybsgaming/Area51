<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnNText&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="nTextModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Text Area</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name"/>
	<input:text type="number" name="editLines" label="Lines" placeHolder="Number of lines to edit"/>
	<div class="form-group">
	<label>Display Mode</label>
	<select class="form-control" name="displayMode">
		<option value="plain">Plain Text</option>
		<option value="rich">Rich Text</option>
		<option value="code" disabled>Prettified Code (coming soon)</option>
	</select>
</div>
	<input:textarea name="default" label="Default Content" placeHolder="Default Value (if any))"/>
	<input:checkbox name="required" label="Required" value="1" placeHolder="Default Value (if any))"/>
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