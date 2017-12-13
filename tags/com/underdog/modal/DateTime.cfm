<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnDateTime&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="dateTimeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Date/Time</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name" required="true"/>
	<input:checkbox name="showDate" label="Show Date" value="1"/>
	<input:checkbox name="showTime" label="Show Time" value="1"/>
	<input:checkbox name="defaultToNow" label="Default to current time" value="1"/>
	<input:text name="date" type="date" label="Date"/>
	<input:text name="time" type="time" label="Time"/>
	<input:text name="dateFormat" label="Date Format" placeholder="e.g: MMM DD YYYY"/>
	<input:text name="timeFormat" label="Time Format" placeholder="e.g: HH:MM:SS"/>

	<input:checkbox name="required" label="Required" value="1"/>
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