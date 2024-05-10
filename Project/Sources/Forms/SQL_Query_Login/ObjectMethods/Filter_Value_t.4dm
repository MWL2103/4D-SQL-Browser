/* Object Method: SQL_Query_Login.Filter_Value_t 
      
  Purpose: Filter_Value_t was tFilterRows
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

//var $Customise_b : Boolean
var Filter_Value_t; $ObjectName_t : Text

Case of 
	: (Form event code=On Load)
		//queryExtraInfo_t:="On Load"
		OBJECT SET VALUE("QueryExtraInfo_t"; "On Load")
		
		//$Customise_b:=True  // Customise the SearchPicker (if needed)
		
		$ObjectName_t:=OBJECT Get name(Object current)
		
		// The exemple below shows how to set a label (ex : "name") inside the search zone
		//If ($Customise_b)
		SearchPicker SET HELP TEXT($ObjectName_t; "Search")
		//End if 
		
	: (Form event code=On Getting Focus)
		Form.Old_Filter_Value_t:=OBJECT Get value("Filter_Value_t")  // Filter_Value_t  // Save current filter value.
		
	: (Form event code=On Losing Focus)
		If (Form.Old_Filter_Value_t#OBJECT Get value("Filter_Value_t"))  // Filter_Value_t)
			FilterRows  // Query selection
		End if 
		
		Form.Old_Filter_Value_t:=OBJECT Get value("Filter_Value_t")  //Filter_Value_t
		
	: (Form event code=On Data Change)
		
		If (FORM Event.objectName="Filter_Value_t")  // (OBJECT Get pointer(Object with focus)=(->Filter_Value_t))
			Case of 
				: (OBJECT Get value("Filter_Value_t")#"")  // (Filter_Value_t#"")  // User typing
					
				: (OBJECT Get value("Filter_Value_t")="")  // (Filter_Value_t="")  // User cleared field
					If (Form.Old_Filter_Value_t#"")
						FilterRows  // Reset selection
					End if 
					
					Form.Old_Filter_Value_t:=OBJECT Get value("Filter_Value_t")  //Filter_Value_t
					
				: (Form.Old_Filter_Value_t#OBJECT Get value("Filter_Value_t"))  // Filter_Value_t)
					// Do nothing
					
				Else 
					// Do nothing
			End case 
			
		Else 
			If (OBJECT Get pointer(Object current)=(->Filter_Value_t))
				
				Case of 
						//: ((Form.Old_Filter_Value_t="") & (Filter_Value_t=""))
					: ((Form.Old_Filter_Value_t="") & (OBJECT Get value("Filter_Value_t")=""))
						// Do nothing
						
						//: (Filter_Value_t="")
					: (OBJECT Get value("Filter_Value_t")="")  // User cleared field
						FilterRows  // Reset selection
						Form.Old_Filter_Value_t:=OBJECT Get value("Filter_Value_t")  //Filter_Value_t
						
					Else 
						// User typing
				End case 
			End if 
		End if 
		
	Else   // Some other event
		// Do nothing
End case 
