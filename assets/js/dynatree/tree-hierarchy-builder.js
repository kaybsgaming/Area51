function TreeHierarchyBuilder()
{
	var self = this;
	
	this._nodeToId = function($node)
	{
		//Get the href attribute of the A tag inside the list node
		href = $node.find('a').attr('href');
	
		//Run a regex to capture the ID get string
		var regex = new RegExp("id=([0-9]+)");
		var regexResult = String(regex.exec(href));
		var id = regexResult.split(",")[1];
		
		//Return the ID alone
		return id;
	}
	
	/**
	*Apply numbering to list items so that updates can occur.
	*
	*Something in DynaTree causes this to re-fire the dragDrop event every time it is called. As such, this should be refactored to instead build its left/right/parent data to a seperate struct instead of applying them to the DOM elements.
	*/
	this.applyHierarchy = function()
	{

		var $pages = $('.dynatree-title');
		var jsonPacket = {};

		//Start numbering over
		self.treeIndex = 1;
		
		//apply numberings; starting with all top-level nodes, apply lefts.
		//every time a node is found to contain nodes, rather than be a bottom level node, traverse into that node and number it instead
		var $parentNodes = $('#navWrapper').find('>ul>li');
		
		$parentNodes.each(function(index, element)
		{
			var $node = $(element);
			var $inner = $node.find('>span>a');
			
			//Apply the left for this
			$node.attr('data-left', self.treeIndex);
			self.treeIndex++;
			
			//Parent nodes have no parent
			$node.attr('data-parent-page-id', '');
			
			//set the page id too
			$node.attr('data-page-id', self._nodeToId($node));
			
			//Does it have children?
			//If so, drop into the child and chew its nodes first
			if($node.find('>ul').length != 0)
			{
				self.recurseChildNodes($node);
			}
			else
			{
				//Else, apply the right
				$node.attr('data-right', self.treeIndex);
				self.treeIndex++;
			}
		});
		
		
		//Now that all the numbering is done, harvest the data into an array blindly
		var jsonPacket = {};
		
		$('#navWrapper li').each(function(index, element)
		{
			var $node = $(element);
			
			var nodePacket = {};
			nodePacket['PageID'] = $node.data('pageId');
			nodePacket['LeftID'] = $node.data('left');
			nodePacket['RightID'] = $node.data('right');
			nodePacket['ParentID'] = $node.data('parentPageId');

			jsonPacket[nodePacket['PageID']] = nodePacket;
		});
		

		
		jsonRequest = $.ajax(
		{
			dataType: "json",
			url: '/?controller=page&do=updateorder',
			data: jsonPacket,
			cache: false,
			type: "POST"
		});
	}
	
	this.treeIndex = 1;
	
	this.recurseChildNodes = function($nodeParent)
	{
		$nodes = $nodeParent.find('>ul>li');
		
		$nodes.each(function(index, element)
		{
			$node = $(element);
			
			$subnodeInner = $node.find('>span>a');
			
			//Attach the left edge and iterate the marker
			$node.attr('data-left', self.treeIndex);
			self.treeIndex++;
			
			//Get the ID of the parent while we're here
			$node.attr('data-parent-page-id', self._nodeToId($nodeParent));
			$node.attr('data-page-id', self._nodeToId($node));
			
			if($node.find('>ul').length != 0)
			{
				self.recurseChildNodes($node);
			}
			else
			{
				$node.attr('data-right', self.treeIndex);
				self.treeIndex++;
				//Apply the right if there are no child node
			}
		});
		
		//After all the numbering, number the parent's right
		$nodeParent.attr('data-right', self.treeIndex);
		self.treeIndex++;
	}
}