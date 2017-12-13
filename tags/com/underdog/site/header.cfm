<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfheader name="pragma" value="no-cache">
<cfheader name="expires" value="#getHttpTimeString(now())#">

<!DOCTYPE html>
<html lang="en">
<head>
	<title>AeroNet Ops | Powered by Underdog</title>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/favicon.ico" type="image/x-icon">
   <!-- CSS Global Compulsory -->
    <link rel="stylesheet" href="/assets/plugins/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/assets/css/style.css">

    <!-- CSS Header and Footer -->
    <link rel="stylesheet" href="/assets/css/headers/header-default.css">
    <link rel="stylesheet" href="/assets/css/footers/footer-v1.css">


    <!-- CSS Implementing Plugins -->
	<link rel="stylesheet" href="/assets/plugins/animate.css">
    <link rel="stylesheet" href="/assets/plugins/line-icons/line-icons.css">
    <link rel="stylesheet" href="/assets/plugins/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="/assets/plugins/glyphicons-pro/glyphicons/web/html_css/css/glyphicons.css">
    <link rel="stylesheet" href="/assets/plugins/glyphicons-pro/glyphicons_halflings/web/html_css/css/halflings.css">
    <link rel="stylesheet" href="/assets/plugins/glyphicons-pro/glyphicons_social/web/html_css/css/social.css">
    <link rel="stylesheet" href="/assets/plugins/glyphicons-pro/glyphicons_filetypes/web/html_css/css/filetypes.css">
    <link rel="stylesheet" href="/assets/plugins/sky-forms-pro/skyforms/css/sky-forms.css">
    <link rel="stylesheet" href="/assets/plugins/sky-forms-pro/skyforms/custom/custom-sky-forms.css">

    <link rel="stylesheet" href="/assets/plugins/line-icons/line-icons.css">
    <link rel="stylesheet" href="/assets/plugins/font-awesome/css/font-awesome.min.css">

    <!-- CSS Customization -->
    <link rel="stylesheet" href="/assets/css/custom.css">

	<link href="/assets/css/tagmanager.css" rel="stylesheet">
	<link href="/assets/css/typeahead.css" rel="stylesheet">


	<style id="antiClickjack">body{display:none !important;}</style><!---Anti clickjacking code (OWASP)) --->
	<script src="/assets/js/blazy.js "></script>
</head>
<body class="header-fixed">
<script type="text/javascript">
   if (self === top) {
       var antiClickjack = document.getElementById("antiClickjack");
       antiClickjack.parentNode.removeChild(antiClickjack);
   } else {
       top.location = self.location;
   }
</script>
<cfparam name="form.search" default="" >
<cfif not(request.isEmailContent)>
 <!--=== Header ===-->
    <div class="header">
        <div class="container">
            <!-- Logo -->
            <a class="logo" href="index.html">
                <img src="/assets/img/black-166x51.png" alt="Logo">
            </a>
            <!-- End Logo -->

            <!-- Topbar -->
            <div class="topbar">
                <ul class="loginbar pull-right">
                	<li><a href="/?controller=profile">Welcome <cfoutput>#session.oUser.username#</cfoutput></a></li>
                	<li class="topbar-divider"></li>
<!---                    <li><a href="/?controller=cmsHelp">Help</a></li>
                    <li class="topbar-divider"></li> --->
                    <li><a href="/?logout">Logout</a>&nbsp;</li>
                </ul>
            </div>
            <!-- End Topbar -->

            <!-- Toggle get grouped for better mobile display -->
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="fa fa-bars"></span>
            </button>
            <!-- End Toggle -->
        </div><!--/end container-->

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse mega-menu navbar-responsive-collapse">
            <div class="container">
                <ul class="nav navbar-nav">
	<!-- Home -->
	<li <cfif not(compareNoCase(request.module,"home"))>class="active"</cfif>><a href="/">Home</a></li>
	<!-- End Home -->

	<!-- Content -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"reports"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Reports</a>
 		<ul class="dropdown-menu">
			<li><a href="/?controller=cron"><i class="fa fa-cogs"></i> Cron Report</a></li>
		</ul>
	</li>
	<!-- end Content -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"tools"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Tools</a>
 		<ul class="dropdown-menu">
			<li><a href="/?controller=SVN"><i class="fa fa-code"></i> SVN Processing</a></li>
		</ul>
	</li>
	<!---

		<li><h3>Tools</h3></li>
		<li><a href="/?controller=SVN"><i class="fa fa-code"></i> SVN Processing</a></li>
	--->
	<!-- Links -->
	<li class="dropdown <cfif not(compareNoCase(request.module,"quicklinks"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="text">Quick Links </span></a>
		<ul class="dropdown-menu">
			<cfif structKeyExists(request,"publicLinks") AND arrayLen(request.publicLinks)>
				<li><a href="#">PUBLIC LINKS</a></li>
				<cfoutput>
				<cfloop array="#request.publicLinks#" index="l">
					<li><a href="#l.geturl()#" <cfif l.getNewWindow()>target="_blank"</cfif>><i class="icon icon-link"></i> #l.getTitle()#</a></li>
				</cfloop>
				</cfoutput>
			</cfif>
			<cfif structKeyExists(request,"privateLinks") AND arrayLen(request.privateLinks)>
				<li><a href="#">PRIVATE LINKS</a></li>
				<cfoutput>
				<cfloop array="#request.privateLinks#" index="l">
					<li><a href="#l.geturl()#" <cfif l.getNewWindow()>target="_blank"</cfif>><i class="icon icon-link"></i> #l.getTitle()#</a></li>
				</cfloop>
				</cfoutput>
			</cfif>
			<li><a href="/?controller=quickLink"><i class="icon icon-plus"> </i> Add/Edit Links....</a></li>
		</ul>
	</li>
	<!-- end Links -->
	<!-- Settings -->
	<li class="dropdown mega-menu-fullwidth <cfif not(compareNoCase(request.module,"Settings"))> active</cfif>">
                        <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
                            Settings
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <div class="mega-menu-content disable-icons">
                                    <div class="container">
                                        <div class="row equal-height">
                                            <div class="col-md-3 equal-height-in">
                                                <ul class="list-unstyled equal-height-list">
                                                    <li><h3>Security</h3></li>
													<li><a href="/?controller=user"><i class="icon icon-user-female"></i> Users</a></li>
													<!--- <li><a href="/?controller=entity"><i class="icon icon-settings"></i> Entities</a></li>--->
													<li><a href="/?controller=role"><i class="icon icon-users"></i> Roles</a></li>
													<!--- <li><a href="/?controller=action"><i class="icon icon-action-redo"></i> Actions</a></li>
													<li><a href="/?controller=profileKey"><i class="icon icon-key"></i> Profile Keys</a></li> --->
                                                    <!-- End Security -->
                                                </ul>
                                            </div>
                                            <div class="col-md-3 equal-height-in">
                                                <ul class="list-unstyled equal-height-list">
                                                    
                                                </ul>
                                            </div>
                                            <!--- <div class="col-md-3 equal-height-in">
                                                <ul class="list-unstyled equal-height-list">
                                                    <li><h3>Content Rendering</h3></li>
                                                   	<li><a href="/?controller=template"><i class="fa fa-code"></i> Templates</a></li>
													<li><a title="" href="/?controller=contentCSS"><i class="icon icon-pencil"></i> CSS</a></li>
                                                </ul>
                                            </div>
                                            <div class="col-md-3 equal-height-in">
                                                <ul class="list-unstyled equal-height-list">
                                                    <li><h3>Settings</h3></li>
													<li><a href="/?controller=plugin"><i class="icon icon-puzzle"></i> Plug Ins</a></li>
													<li><a title="" href="/?controller=constant"><i class="icon icon-settings"></i> Constants</a></li>
													<cfif cgi.server_name contains ".local.com">
														<!-- Concepts -->
														<li><a href="/?controller=concepts"><i class="icon icon-energy"></i>&nbsp;Concepts</a></li>
														<!-- end Concepts -->
													</cfif>
													<li><a title="" href="/?controller=tag"><i class="icon icon-tag"></i> Tags</a></li>
													<li><a title="" href="/?controller=tools"><i class="icon icon-wrench"></i> Tools</a></li>
													<!-- About -->
													<li><a title="" href="/?controller=about"><i class="icon icon-info"></i> About</a></li>
                                                </ul> --->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <!-- end Settings -->
	
	<!---
    <!-- Search Block -->
    <li>
        <i class="search fa fa-search search-btn"></i>
        <div class="search-open">
        	  <form class="form-inline" role="form" action="/?controller=search" method="post"">
            <div class="input-group form-group animated fadeInDown">
                <input type="text" name="search" class="form-control" placeholder="Search">
                <span class="input-group-btn">
                    <button type="submit" class="btn-u">Go</button>
                </span>
            </div>
			</form>
        </div>    
    </li>
    <!-- End Search Block -->
    --->
</ul>
            </div><!--/end container-->
        </div><!--/navbar-collapse-->
    </div>
    <!--=== End Header ===-->

</cfif>
    <!--=== End Breadcrumbs ===-->
<!---<div class="header">
        <div class="container pull-left">
            <!-- Logo -->
            <a class="logo" href="/">
                <img src="/assets/img/black-166x51.png" alt="Logo">
            </a>
            <!-- End Logo -->
            
            <!-- Topbar -->
            <div class="topbar">
                <ul class="loginbar pull-right">
                    <cfoutput><li><a href="##">Welcome, #session.oUser.getUserName()#</a></li></cfoutput>  
                    <li class="topbar-divider"></li>
					<li><a href="/?controller=cmsHelp">Help</a></li>
					 <li class="topbar-divider"></li>      
                    <cfoutput><li><a href="/?logout=#createUUID()#">Logout</a></li></cfoutput>   
                </ul>
            </div>
            <!-- End Topbar -->

            <!-- Toggle get grouped for better mobile display -->
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="fa fa-bars"></span>
            </button>
            <!-- End Toggle -->
        </div><!--/end container-->

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse mega-menu navbar-responsive-collapse">
            <div class="container">
<ul class="nav navbar-nav">
	<!-- Home -->
	<li <cfif not(compareNoCase(request.module,"home"))>class="active"</cfif>><a href="/">Home</a></li>
	<!-- End Home -->

	<!-- Images -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"images"))> active</cfif>">
 		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Images</a>
		<ul class="dropdown-menu">
			<li><a href="/?controller=contentImage"><i class="icon icon-picture"></i> Image Library</a></li>
			<li><a href="/?controller=contentImage&do=upload"><i class="icon icon-cloud-upload"></i> Upload Images</a></li>
		</ul>
	</li>
	<!-- end Images -->

	<!-- Files -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"files"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Files</a>
		<ul class="dropdown-menu">
			<li><a href="/?controller=contentFile"><i class="icon icon-docs"></i> File Library</a></li>
			<li><a href="/?controller=contentFile&do=upload"><i class="icon icon-cloud-upload"></i> Upload Files</a></li>
		</ul>
	</li>
	<!-- end Files -->

	<!-- Content -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"content"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Content</a>
 		<ul class="dropdown-menu">
			<li><a href="/?controller=contentNews"><i class="icon icon-book-open"></i> News/Blog Posts</a></li>	        	
			<li><a href="/?controller=contentHero"><i class="icon icon-paper-plane"></i> Heroes</a></li>
		</ul>
	</li>
	<!-- end Content -->
	<li><a href="/?controller=list">Custom Lists</a></li>	
	<cfif cgi.server_name contains ".local.com">
	<!-- Concepts -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"wip"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">Concepts</a>
		<ul class="dropdown-menu">
			<li><a href="/?controller=product">Products</a></li>
			<li><a href="/?controller=vimeo">Vimeo Integration</a></li>		
		</ul>
	</li>
	
	<!-- end Concepts -->
	</cfif>
	<!-- Links -->
	<li class="dropdown <cfif not(compareNoCase(request.module,"quicklinks"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="text">Quick Links </span></a>
		<ul class="dropdown-menu">
			<cfif structKeyExists(request,"publicLinks") AND arrayLen(request.publicLinks)>
				<li><a href="#">PUBLIC LINKS</a></li>
				<cfoutput>
				<cfloop array="#request.publicLinks#" index="l">
					<li><a href="#l.geturl()#" <cfif l.getNewWindow()>target="_blank"</cfif>><i class="icon icon-link"></i> #l.getTitle()#</a></li>
				</cfloop>
				</cfoutput>
			</cfif>
			<cfif structKeyExists(request,"privateLinks") AND arrayLen(request.privateLinks)>
				<li><a href="#">PRIVATE LINKS</a></li>
				<cfoutput>
				<cfloop array="#request.privateLinks#" index="l">
					<li><a href="#l.geturl()#" <cfif l.getNewWindow()>target="_blank"</cfif>><i class="icon icon-link"></i> #l.getTitle()#</a></li>
				</cfloop>
				</cfoutput>
			</cfif>
			<li><a href="/?controller=quickLink"><i class="icon icon-plus"> </i> Add/Edit Links....</a></li>
		</ul>
	</li>
	<!-- end Links -->
	<!-- Settings -->
	<li class="dropdown<cfif not(compareNoCase(request.module,"Settings"))> active</cfif>">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="text">Settings </span></a>
		<ul class="dropdown-menu">
			<li><a href="/?controller=template"><i class="fa fa-code"></i> Templates</a></li>
			<li><a href="/?controller=contentJSON"><i class="icon icon-puzzle"></i> JSON Objects</a></li>
			<li><a title="" href="/?controller=constant"><i class="icon icon-settings"></i> Constants</a></li>
			<li><a title="" href="/?controller=contentCSS"><i class="icon icon-pencil"></i> CSS</a></li>
			<li class="dropdown-submenu">
				<a href="javascript:void(0);"><i class="icon icon-lock"></i>&nbsp;Security</a>
				<ul class="dropdown-menu">
					<li><a href="/?controller=action"><i class="icon icon-wrench"></i>Actions</a></li>
					<li><a href="/?controller=entity"><i class="icon icon-grid"></i> Entities</a></li>
					<li><a href="/?controller=role"><i class="icon icon-users"></i> Roles</a></li>
					<li><a href="/?controller=user"><i class="icon icon-user-female"></i> Users</a></li>
				</ul>                                
			</li>
			<li><a title="" href="/?controller=tag"><i class="icon icon-tag"></i> Tags</a></li>
			<li><a title="" href="/?controller=tools"><i class="icon icon-wrench"></i> Tools</a></li>
			<!-- Deprecated -->
			<li class="dropdown-submenu">
				<a href="javascript:void(0);"><i class="icon icon-ghost"></i> Deprecated</a>
				<ul class="dropdown-menu">
					<li><a href="/?controller=contentText">Text Blocks</a></li>
					<li><a href="/?controller=contentSideKick">Sidekicks</a></li>
					<li><a href="/?controller=contentOffer">Calls to Action</a></li>
				</ul>                                
			</li>
			<!-- end Deprecated -->
			<!-- About -->
			<li><a title="" href="/?controller=about"><i class="icon icon-info"></i> About</a></li>
		</ul>
	</li>
	<!-- end Settings -->
	<!---
    <!-- Search Block -->
    <li>
        <i class="search fa fa-search search-btn"></i>
        <div class="search-open">
        	  <form class="form-inline" role="form" action="/?controller=search" method="post"">
            <div class="input-group form-group animated fadeInDown">
                <input type="text" name="search" class="form-control" placeholder="Search">
                <span class="input-group-btn">
                    <button type="submit" class="btn-u">Go</button>
                </span>
            </div>
			</form>
        </div>    
    </li>
    <!-- End Search Block -->
    --->
</ul>
	



            </div><!--/end container-->
        </div><!--/navbar-collapse-->
    </div>
--->
