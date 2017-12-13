<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnChoice&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="choiceModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Choice</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" required="true" placeHolder="Column Name"/>
	<input:text name="default" label="Default" placeHolder="Default Value (if any))"/>
	<input:textArea name="choices" required="true" label="choices">Option A
Option B
Option C</input:textArea>

<label class="radio"><input type="radio" name="displayMode" value="select" checked=""><i class="rounded-x"></i>Select Box</label>
<label class="radio"><input type="radio" name="displayMode" value="multiSelect" checked=""><i class="rounded-x"></i>Multi-select Box</label>
<label class="radio"><input type="radio" name="displayMode" value="radio" checked=""><i class="rounded-x"></i>Radio Buttons</label>
<label class="radio"><input type="radio" name="displayMode" value="checkbox" checked=""><i class="rounded-x"></i>Checkboxes</label>
	

	<input:checkbox name="required" label="Required" value="1" placeHolder="Required"/>
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