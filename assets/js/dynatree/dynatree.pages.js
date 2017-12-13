//On page load, instantiate and trigger the basic drag/drop method for the dynatree
$(function()
{
	if(typeof dynatreePages == 'undefined')
	{
		var dynatreePages = new DynatreePages();
		dynatreePages.initializeDragDrop();
		dynatreePages.bindEvents();
		
	}
});

function DynatreePages()
{
	//Scope resolution
	var self = this;
	
	//UI lock status
	this.locked = false;
	/*
	*Set up UI events
	*/
	this.bindEvents = function()
	{
		//Fix for the navigation tree not allowing for navigation
		$('#navWrapper .dynatree-title').off('click');
		$('#navWrapper .dynatree-title').on('click', function()
		{
			window.location.href = $(this).attr('href');
		});
	}

	/**
	*Initializes the Drag/Drop dynatree object
	*/
	this.initializeDragDrop = function()
	{
		$('#navWrapper').css('display', 'block');
		$('#navWrapper ul li').addClass('expanded');
		
		$("#navWrapper").dynatree(
		{
			onActivate: function(node) 
			{
				//alert("You activated " + node);
				//debug.log(node);
			},
			generateIds: true,
			debugLevel: 0,
			persist: true,
			cookieId: "springboardDynatree", // Choose a more unique name, to allow multiple trees.
    			cookie: {
        				expires: 365 // Days or Date; null: session cookie
    			},
			dnd: 
			{
				autoExpandMS: 1000,
				preventVoidMoves: true,
				onDragStart: function(node) 
				{
					return true;
				},
				onDragStop: function(node) 
				{
					// This function is optional.
					//ogMsg("tree.onDragStop(%o)", node);
				},
				onDragEnter: function(node, sourceNode) 
				{
					return true;
				},
				onDragOver: function(node, sourceNode, hitMode) 
				{
					// Prevent dropping a parent below it's own child
					if(node.isDescendantOf(sourceNode)){
						return false;
					}
				},
				onDragLeave: function(node, sourceNode) {
					/** Always called if onDragEnter was called.
					 */
					//logMsg("tree.onDragLeave(%o, %o)", node, sourceNode);
				},
				onDrop: function(node, sourceNode, hitMode, ui, draggable) 
				{
					if(self.locked)
					{
						return false;
					}
					else
					{
						// We use a customised move function...
						// targetParent.childList.push(this); -> targetParent.childList.unshift(this);
						sourceNode.move(node, hitMode);

						self.updateOrdering(node, sourceNode, hitMode);
					}

					self.bindEvents();
				}
			},
			onExpand: function(flag, node) {
				self.bindEvents();
			}
		});

	}
	
	/**
	*Locks the UI while a reorder is occuring so that no conflicts can occur
	*/
	this.lockUI = function()
	{
		self.locked = true;
		
		console.log('locked UI');
		
		$('#navWrapper').append('<div class="blocker">Updating...</div>');
		
		var $wrapper = $('#navWrapper');
		var $blocker = $('#navWrapper .blocker');
		
		$blocker.css('width', $wrapper.outerWidth(true));
		$blocker.css('height', $wrapper.outerHeight(true));
	}
	
	/**
	*Release the UI lock so that reordering can continue
	*/
	this.releaseUI = function()
	{
		self.locked = false;
		
		console.log('update done, unlocking');
		
		$('#navWrapper .blocker').remove();
	}
	
	/**
	*Brute force UI reorder - get the leafing of the entire tree and then update every item in place
	*/
	this.updateOrdering = function(node, sourceNode, hitMode)
	{
		//Only allow one update at a time
		if(self.locked)
		{
			return false;
		}
		
		//Lock the UI from further updates
		self.lockUI();

		var jsonPacket = {};
		jsonPacket['nodeId'] = self.getNodeId(node);
		jsonPacket['sourceNodeId'] = self.getNodeId(sourceNode);
		jsonPacket['hitMode'] = hitMode;

		jsonRequest = $.ajax(
		{
			dataType: "json",
			url: '/?controller=leaf&do=updateorder',
			data: jsonPacket,
			cache: false,
			type: "POST"
		});

		jsonRequest.done(function()
		{
			//Release the UI
			self.releaseUI();
		});
	}

	this.getNodeId = function(node)
	{
		//Get the href attribute of the A tag inside the list node
		var href = node.data.href;

		//Run a regex to capture the ID get string
		var regex = new RegExp("id=([0-9]+)");
		var regexResult = String(regex.exec(href));
		var id = regexResult.split(",")[1];

		//Return the ID alone
		return id;
	}
}