/* Object Method: Confirm2.CoNF_Icon_pic 
      
  Purpose: xxXxx 
      
  Parameters: None 

  Version: 1.0 - 05/13/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $IconName_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		$IconName_t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Icons"+Folder separator:K24:12+"ICON_"+Form:C1466.CoNF_IconName_t+".png"
		
		READ PICTURE FILE:C678($IconName_t; OBJECT Get pointer:C1124(Object current:K67:2)->)
		
	Else   // Some other event
		// Do nothing
End case 
