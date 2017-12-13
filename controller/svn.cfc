component {

    public function init(){
        return this;
    }
	
	public string function default(){
		return "/view/svn/default.cfm";
	}

	public string function process(){
		request.csv = wrangleChangeLogs(form.sourceFile, false);
		return "/view/svn/process.cfm";
	}
     /*
    Function to process SVN change log txt files into a meaningful CSV that we can supply to Product Owners for regression testing
    */
    private string function wrangleChangeLogs(string sourceFile, boolean updates = false){
		var out = fileRead(arguments.sourceFile);
		out = replaceNoCase(out,chr(10)&chr(10),chr(10),"ALL");                 // replace double breaks with a single break
		out = replaceNoCase(out,chr(9),"","ALL");                               // remove Tabs
		out = replaceNoCase(out,chr(10)&chr(32)&chr(32),chr(32),"ALL");         // replace a line break and double space with a single space
		out = replaceNoCase(out, chr(10)&"*"&chr(32),",","ALL");                // replace line break and the asterisk prefix for time entry with a comma

		// now it gets interesting
		out = replaceNoCase(out,chr(10)," ","ALL");                             // replace all line breaks with a space
		out = replaceNoCase(out,"2017",chr(10)&"2017","ALL");                   // now reinstate the lines, based on the leading year (each line starts with a yyyy-mm-dd date entry)
		out = replaceNoCase(out,"2016",chr(10)&"2016","ALL");
		out = replaceNoCase(out,"2015",chr(10)&"2015","ALL");

		// now that we have reinstated our lines....
		out = replaceNoCase(out," [",",[","ALL");                               // tidy up the leading [ on commit keys
		out = replaceNoCase(out,"]  ","],","ALL");                              // tidy up the trailing ] on commit keys
		
		// tidy up user names
		out = replaceNoCase(out,"jobyc:,","jobyc,"&chr(34),"ALL");
		out = replaceNoCase(out,"luis:,","luis,"&chr(34),"ALL");
		out = replaceNoCase(out,"dhunter:,","dhunter,"&chr(34),"ALL");
		out = replaceNoCase(out,"wade:,","wade,"&chr(34),"ALL");
		out = replaceNoCase(out,"dean:,","dean,"&chr(34),"ALL");
		out = replaceNoCase(out,"brody:,","brody,"&chr(34),"ALL");
		out = replaceNoCase(out,"svn:,","svn,"&chr(34),"ALL");
		out = replaceNoCase(out,"ernus:,","ernus,"&chr(34),"ALL");
		
		out = replaceNoCase(out,chr(10),chr(34)&chr(10),"ALL");                 // replace the end of each line with a double quote and a line break
		
		// if the first line in the file is a line break, get rid of it
		if (left(out,1) is chr(10))
			out = replaceNoCase(out,chr(10),"","ONCE");


        // now we're going to strip out the task names using RegEx, and add them to the first column in the CSV we are creating
		var test = listToArray(out,chr(10));                                    // turn the list (delimited by line breaks) into an array
		out = "";                                                               // clear out the output variable (we will repopulate it as we go)
		for (var l in test){                                                    // loop over the array we created
			if (listLen(l) gt 1){                                               // if its a meaningful row, then process it
				
				var temp = reMatchNoCase("([A-Z]+-[0-9])\w+",l);                // temp ends up being an array of items that match the RegEx (sometimes with mulitple entries, you will get multiple responses)
				var issue = arrayLen(temp) gt 0 ? ucase(temp[1]) : "N/A";       // if we find a result, use the first Jira Code as the reference, otherwise use "N/A" 
				out = out & issue & "," & l & chr(10);                          // add the line in the CSV on the end of the Jira issue, and we're good to go
				
			}
		}
		out = out&chr(34);                                                      // add a double quote on the end of the file (the last line)
		out = "Issue,Date,Commit,Person,Details"&chr(10)&out                    // add the header row

	return out;
	}
}