//%attributes = {"invisible":true}
/* Method: SQL_Pretty_Print
      
  Purpose: Highlights SQL commands.
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Found_1_Match_b; $Match_1_b; $Match_2_b; $Match_3_b; $Match_4_b : Boolean
var $Cursor_End_l; $Cursor_Start_l; $Len_l; $Pos_1_l; $Pos_2_l; $Pos_3_l : Integer
var $Pos_4_l; $Row_l; $Rows_l; $Start_l : Integer
var $Command_1_t; $End_Span_t; $Header_t; $RegEx_1_t; $RegEx_2_t; $RegEx_3_t : Text
var $RegEx_4_t; $Result_t; $SQL_t; $Start_Span_1_t; $Start_Span_2_t : Text
var $Start_Span_3_t; $Start_Span_4_t; $Text_t : Text

If (False)
	
	Begin SQL
		SELECT Coalesce(c.ID_PK,-999999)AS 'ID_PK', p.ContractNumber AS 'CONTRACT NO', 
		CASE WHEN Length(p.ConversionFrom)>0 THEN Concat(p.ConversionFrom,p.ReplacesContractNumber) 
		WHEN p.isReplacement_wo=True THEN Concat('REPLACED WO ',p.ReplacesContractNumber) 
		ELSE p.ReplacesContractNumber END AS 'REPLACED CONTRACT', 
		CASE WHEN p.Status='DFT' THEN Concat(Concat(p.Status,' ON '),Date_to_char(p.Date_DFT, 'MM/DD/YY')) 
		ELSE p.Status END AS 'STATUS', Coalesce(c.Users_ID_SK_FK,-999999) 
		AS 'USER ID', p.AgentNumber AS 'AGENT NO', p.BrokerNumber AS 'BROKER NO', c.Reduction_RecNo AS 'REDUCTION ID', c.Status, 
		CASE WHEN p.Current_Balance <= 0 THEN 'PAID' 
		WHEN p.Current_Balance<p.PurchasedCommission THEN 'PAID SHORT' 
		ELSE 'UNPAID' END AS 'PAYMENT', p.Date_Funded AS 'FUNDED', p.Date_Repaid, p.Date_OriginalClosing AS 'CLOSED(ORIG.)', 
		p.Date_Closing AS 'CLOSED(CURNT)', p.Current_Balance AS 'CURRENT BALANCE', p.PurchasedCommission AS 'PURCH. COMM', 
		a.Type, p.PurchasedCommission-d.Amount_Deposit AS 'AMOUNT DUE', a.Description, p.isRepaid, a.Paid_In_Full, 
		u.isActive AS 'ACTIVE USER', p.isReplacement_wo
		
		FROM Pending_Contracts AS p
		INNER JOIN Contract_Key AS c ON c.ContractNumber_FK=p.ContractNumber
		INNER JOIN Users AS u ON u.ID_SK=c.Users_ID_SK_FK
		LEFT OUTER JOIN Adjustments AS a ON a.ContractNumber=p.ContractNumber
		LEFT OUTER JOIN Deposits AS d ON d.ContractNumber=p.ContractNumber
		WHERE p.BrokerNumber = (
		SELECT BrokerNumber FROM Pending_Contracts WHERE ContractNumber like '16-165282'
		)
		ORDER BY p.ContractNumber, c.Reduction_RecNo
	End SQL
	
End if 

If (OBJECT Get value("Style_SQL_cb_l")=1)  // If Style SQL checkbox is checked
	Case of   // Do nothing, but accept the keystroke
			//: (Character code(Keystroke)=Backspace)
			//: (Character code(Keystroke)=Return key)
		: (Character code(Keystroke)=Left arrow key)
		: (Character code(Keystroke)=Right arrow key)
		: (Character code(Keystroke)=Up arrow key)
		: (Character code(Keystroke)=Down arrow key)
		Else   // If not filtered, then apply RegEx
			
			//$Header_t:="<span style=\"font-family:'Menlo';font-size:12pt\">"
			//$Header_t:="<span style='font-size:12pt;font-weight:normal;color:#000000'>"
			//$Header_t:="<span style=\"font-family:'Menlo';font-weight:normal;font-size:13pt;color:#000000'\">"
			//$Header_t:="<span style=\"font-family: Arial;font-weight:normal;font-size:13pt;color:#000000'\">"
			$Header_t:="<span style=\"font-family:'Menlo';font-weight:normal;font-size:12pt;color:#000000'\">"
			
			
			$End_Span_t:="</span>"
			//----------------------------------------------------
			// Commands and commented out lines
			$RegEx_1_t:="(?mi-s)(-{2}.*)|'([^']|\\\\')*'|(\\bUPDATE\\b|\\bFOR UPDATE\\b|\\bSELECT\\b|\\bAS\\b|\\bCASE\\b|\\bWHEN\\b|\\bAND\\b|\\bTHEN\\b|\\bELSE\\b|\\bEND\\b|\\bON\\b"+\
				"|\\bFROM\\b|\\bDELETE FROM\\b|\\bHAVING\\b|\\bGROUP BY\\b|\\bLIMIT\\b|\\bOFFSET\\b|\\bVALUES\\b|\\bLIKE\\b|\\bTRUE\\b|\\bFALSE\\b|\\bIN\\b|\\bSET\\b|\\bOR\\b"+\
				"|\\bINNER JOIN\\b|\\bLEFT OUTER JOIN\\b|\\bWHERE\\b|\\bORDER BY\\b|\\bASC\\b|\\bDESC\\b|\\bINSERT INTO\\b|\\bEXISTS\\b|\\bNULL\\b|\\bIS NULL\\b|\\bIS NOT NULL\\b|\\bBETWEEN\\b"+\
				"|\\bNOT\\b|\\bALTER DATABASE\\b|\\bCREATE TABLE\\b|\\bCREATE INDEX\\b|\\bDROP INDEX\\b|\\bLOCK TABLE\\b|\\bUNLOCK TABLE\\b|\\bCREATE SCHEMA\\b"+\
				"|\\bALTER SCHEMA\\b|\\bDROP SCHEMA\\b|\\bCREATE VIEW\\b|\\bPRIMARY KEY\\b|\\bDROP VIEW\\b|\\bGRANT\\b|\\bANY\\b|\\bALL\\b|\\bSOME\\b|\\bESCAPE\\b)"
			
			$RegEx_1_t:="(?mi-s)(-{2}.*)|'([^']|\\\\')*'|\\b(UPDATE|FOR UPDATE|SELECT|AS|CASE|WHEN|AND|THEN|ELSE|END|ON|FROM|DELETE FROM|HAVING|G"+\
				"ROUP BY|LIMIT|OFFSET|VALUES|LIKE|TRUE|FALSE|IN|SET|OR|INNER JOIN|LEFT OUTER JOIN|WHERE|ORDER BY|ASC|DESC|INSERT INTO|EXI"+\
				"STS|NULL|IS NULL|IS NOT NULL|BETWEEN|NOT|ALTER DATABASE|CREATE TABLE|CREATE INDEX|DROP INDEX|LOCK TABLE|UNLOCK TABLE|CRE"+\
				"ATE SCHEMA|ALTER SCHEMA|DROP SCHEMA|CREATE VIEW|PRIMARY KEY|DROP VIEW|GRANT|ANY|ALL|SOME|ESCAPE)\\b"
			
			$Start_Span_1_t:="<span style='color:#29690A;font-weight:bold'>"  // Dark green
			$Start_Span_1_t:="<span style='color:#006600;font-weight:bold'>"  // Light green
			$Start_Span_1_t:="<span style='color:#048C00;font-weight:bold'>"  // Light green
			//----------------------------------------------------
			// Functions
			$RegEx_2_t:="(?mi-s)(-{2}.*)|'([^']|\\\\')*'|(?<!')(\\bABS\\b|\\bACOS\\b|\\bASCII\\b|\\bASIN\\b|\\bATAN\\b|\\bATAN2\\b|\\bAVG\\b|\\bBIT_LENGTH\\b|\\bCAST\\b|\\bCEILING\\b"+\
				"|\\bCHAR\\b|\\bCHAR_LENGTH\\b|\\bCOALESCE\\b|\\bCONCAT\\b|\\bCONCATENATE\\b|\\bCOS\\b|\\bCOT\\b|\\bCOUNT\\b|\\bCURDATE\\b"+\
				"|\\bCURRENT_DATE\\b|\\bCURRENT_TIME\\b|\\bCURRENT_TIMESTAMP\\b|\\bCURTIME\\b|\\bDATABASE_PATH\\b|\\bDATE_TO_CHAR\\b|\\bDAY\\b|\\bDAYNAME\\b"+\
				"|\\bDAYOFMONTH\\b|\\bDAYOFWEEK\\b|\\bDAYOFYEAR\\b|\\bDEGREES\\b|\\b\\bDISTINCT\\b\\b|\\bEXP\\b|\\bEXTRACT\\b|\\bFLOOR\\b|\\bHOUR\\b|\\bINSERT(?! INTO)\\b"+\
				"|\\bLEFT(?:OUTER)\\b|\\bLENGTH\\b|\\bLOCATE\\b|\\bLOG\\b|\\bLOG10\\b|\\bLOWER\\b|\\bLTRIM\\b|\\bMAX\\b|\\bMILLISECOND\\b|\\bMIN\\b"+\
				"|\\bMINUTE\\b|\\bMOD\\b|\\bMONTH\\b|\\bMONTHNAME\\b|\\bNULLIF\\b|\\bOCTET_LENGTH\\b|\\bPI\\b|\\bPOSITION\\b|\\bPOWER\\b|\\bQUARTER\\b"+\
				"|\\bRADIANS\\b|\\bRAND\\b|\\bREPEAT\\b|\\bREPLACE\\b|\\bRIGHT(?:OUTER)\\b|\\bROUND\\b|\\bRTRIM\\b|\\bSECOND\\b|\\bSIGN\\b|\\bSIN\\b"+\
				"|\\bSPACE\\b|\\bSQRT\\b|\\bSUBSTRING\\b|\\bSUM\\b|\\bTAN\\b|\\bTRANSLATE\\b|\\bTRIM\\b|\\bTRUNC\\b|\\bTRUNCATE\\b|\\bUPPER\\b"+\
				"|\\bWEEK\\b|\\bYEAR\\b)(?!')"
			
			$RegEx_2_t:="(?mi-s)(-{2}.*)|'([^']|\\\\')*'|(?<!')\\b(ABS|ACOS|ASCII|ASIN|ATAN|ATAN2|AVG|BIT_LENGTH|CAST|CEILING|CHAR|CHAR_LENGTH|"+\
				"COALESCE|CONCAT|CONCATENATE|COS|COT|COUNT|CURDATE|CURRENT_DATE|CURRENT_TIME|CURRENT_TIMESTAMP|CURTIME|DATABASE_PATH|DATE_TO_CHAR"+\
				"|DAY|DAYNAME|DAYOFMONTH|DAYOFWEEK|DAYOFYEAR|DEGREES|\\bDISTINCT\\b|EXP|EXTRACT|FLOOR|HOUR|INSERT(?! INTO)|LEFT(?:OUTER)"+\
				"|LENGTH|LOCATE|LOG|LOG10|LOWER|LTRIM|MAX|MILLISECOND|MIN|MINUTE|MOD|MONTH|MONTHNAME|NULLIF|OCTET_LENGTH|PI|POSITION"+\
				"|POWER|QUARTER|RADIANS|RAND|REPEAT|REPLACE|RIGHT(?:OUTER)|ROUND|RTRIM|SECOND|SIGN|SIN|SPACE|SQRT|SUBSTRING|SUM|TAN|TRANSLATE"+\
				"|TRIM|TRUNC|TRUNCATE|UPPER|WEEK|YEAR)\\b(?!')"
			$Start_Span_2_t:="<span style='color:#942192;font-weight:bold'>"
			$Start_Span_2_t:="<span style='color:#862353;font-weight:bold'>"
			$Start_Span_2_t:="<span style='color:#660000;font-weight:bold'>"
			//----------------------------------------------------
			// Strings within single quotes
			//$RegEx_3_t:="(?mi-s)'[^'"+Char(Carriage return)+"]*'"
			//$RegEx_3_t:="(?mi-s)'((?:\\\\.|[^'\\\\])*)'"
			//$RegEx_3_t:="(?mi-s)'\\b((?:\\\\.|[^'\\\\])*)\\b'"
			$RegEx_3_t:="(?mi-s)(['])(?:(?=(\\\\?))\\2.)*?\\1|-{2}.*$"  // Match single quotes OR -- comments
			$RegEx_3_t:="(?mi-s)(-{2}.*)|'([^']|\\\\')*'"  // Match everthing within sing quotes (inclusive) OR comments
			$Start_Span_3_t:="<span style='color:#FD4dFC'>"  // Magenta
			$Start_Span_3_t:="<span style='color:#0000FF'>"  // Blue
			$Start_Span_3_t:="<span style='color:#FF1E1E'>"  // Orange
			//----------------------------------------------------
			// Commented out line
			$RegEx_4_t:="(?mi-s)-{2}.*$"
			$RegEx_4_t:="(?mi-s)--.*$"
			
			$Start_Span_4_t:="<span style='color:#FF0000'>"  // Red
			//----------------------------------------------------
			//$SQL_t:=Get edited text
			//$SQL_t:=ST Get plain text(*;"SQL_Query_t";ST Text displayed with 4D Expression values)
			GET HIGHLIGHT(*; "SQL_Query_t"; $Cursor_Start_l; $Cursor_End_l)  // Get the cursor position
			$SQL_t:=ST Get plain text(*; "SQL_Query_t")
			
			$SQL_t:=Replace string($SQL_t; "&"; "&amp;")  // This must be converted first
			$SQL_t:=Replace string($SQL_t; "<"; "&lt;")  // The order of conversion from here on out is inconsequential
			$SQL_t:=Replace string($SQL_t; ">"; "&gt;")
			
			$Result_t:=""
			$Pos_1_l:=1
			$Pos_2_l:=1
			$Pos_3_l:=1
			$Pos_4_l:=1
			$Start_l:=0
			$Len_l:=0
			$Found_1_Match_b:=False
			
			ARRAY LONGINT($Start_al; 0)
			$Start_al{0}:=0  // Set to zero for testing start positions
			ARRAY TEXT($Match_at; 0)
			ARRAY LONGINT($Type_al; 0)
			ARRAY LONGINT($Length_al; 0)
			If (Caps lock down)
				//TRACE
			End if 
			
			C_BOOLEAN($Match_1_b; $Match_2_b; $Match_3_b; $Match_4_b)
			Repeat 
				//---------------------------------------------------- Commented out line
				//$Match_4_b:=Match regex($RegEx_4_t;$SQL_t;$Pos_4_l;$Start_l;$Len_l)
				//If ($Match_4_b=True)
				//  //$Command_1_t:=Substring($SQL_t;$Start_l;$Len_l)  // Don't change case
				//APPEND TO ARRAY($Start_al;$Start_l)
				//APPEND TO ARRAY($Length_al;$Len_l)
				//APPEND TO ARRAY($Match_at;Substring($SQL_t;$Start_l;$Len_l))
				//APPEND TO ARRAY($Type_al;4)  // Comment Match Type
				//$Pos_4_l:=$Start_l+$Len_l
				//$Found_1_Match_b:=True
				
				//End if 
				//---------------------------------------------------- Commands
				$Match_1_b:=Match regex($RegEx_1_t; $SQL_t; $Pos_1_l; $Start_l; $Len_l)
				If ($Match_1_b=True)
					$Pos_1_l:=$Start_l+$Len_l
					$Text_t:=Substring($SQL_t; $Start_l; $Len_l)
					$Found_1_Match_b:=True
					
					Case of 
						: ($Text_t="--@")  // If this is a comment
							APPEND TO ARRAY($Start_al; $Start_l)
							APPEND TO ARRAY($Length_al; $Len_l)
							APPEND TO ARRAY($Match_at; $Text_t)
							APPEND TO ARRAY($Type_al; 4)  // Match Type = Comment
							
						: ($Text_t="'@")  // If this is a string
							// Do nothing
							
						Else   // This is a Command
							APPEND TO ARRAY($Start_al; $Start_l)
							APPEND TO ARRAY($Length_al; $Len_l)
							APPEND TO ARRAY($Match_at; Uppercase($Text_t))
							APPEND TO ARRAY($Type_al; 1)  // Match Type = Command
					End case 
					SORT ARRAY($Start_al; $Length_al; $Match_at; $Type_al; >)  // DELETE THIS LINE LATER - ONLY USED FOR TESTING
				End if 
				
				//---------------------------------------------------- Functions
				$Match_2_b:=Match regex($RegEx_2_t; $SQL_t; $Pos_2_l; $Start_l; $Len_l)
				If ($Match_2_b=True)
					$Pos_2_l:=$Start_l+$Len_l
					$Text_t:=Substring($SQL_t; $Start_l; $Len_l)
					Case of 
						: ($Text_t="--@")  // If this is a comment
							// Do nothing
							
						: ($Text_t="'@")  // If this is a string
							// Do nothing
							
						Else 
							APPEND TO ARRAY($Start_al; $Start_l)
							APPEND TO ARRAY($Length_al; $Len_l)
							APPEND TO ARRAY($Match_at; Uppercase(Substring($SQL_t; $Start_l; 1))+Lowercase(Substring($SQL_t; $Start_l+1; $Len_l-1)))
							APPEND TO ARRAY($Type_al; 2)  // Match Type = Function
							$Found_1_Match_b:=True
							SORT ARRAY($Start_al; $Length_al; $Match_at; $Type_al; >)  // DELETE THIS LINE LATER - ONLY USED FOR TESTING
					End case 
					
				End if 
				
				//---------------------------------------------------- Strings within single quotes
				$Match_3_b:=Match regex($RegEx_3_t; $SQL_t; $Pos_3_l; $Start_l; $Len_l)
				If ($Match_3_b=True)
					$Pos_3_l:=$Start_l+$Len_l
					$Text_t:=Substring($SQL_t; $Start_l; $Len_l)
					If ($Text_t="--@")  // If this is a comment
						// Do nothing
						
					Else 
						APPEND TO ARRAY($Start_al; $Start_l)
						APPEND TO ARRAY($Length_al; $Len_l)
						APPEND TO ARRAY($Match_at; Substring($SQL_t; $Start_l; $Len_l))  // Don't change case
						APPEND TO ARRAY($Type_al; 3)  // Match Type = String
						SORT ARRAY($Start_al; $Length_al; $Match_at; $Type_al; >)  // DELETE THIS LINE LATER - ONLY USED FOR TESTING
						$Found_1_Match_b:=True
					End if 
				End if 
				
				//----------------------------------------------------
			Until ($Match_1_b=False) & ($Match_2_b=False) & ($Match_3_b=False) & ($Match_4_b=False)
			
			If ($Found_1_Match_b=True)  // There we at least one match
				//OBJECT SET COLOR(*;"SQL_Query_t";-(black+(256*white)))
				//CLEAR VARIABLE((OBJECT Get pointer(Object named;"SQL_Query_t"))->)
				//ST SET TEXT(*;"SQL_Query_t";"<span></span>")  // Must clear variable before reassigning the text
				ST SET TEXT(*; "SQL_Query_t"; "<span style='font-size:12pt;font-weight:normal;color:#000000'></span>")
				
				SORT ARRAY($Start_al; $Length_al; $Match_at; $Type_al; >)  // Sort so smallest position is on top
				
				$Rows_l:=Size of array($Start_al)
				For ($Row_l; 1; $Rows_l)
					Case of 
						: ($Start_al{0}=-1)
							// Skip this loop
							
						: ($Row_l<$Rows_l)
							Case of 
								: ($Type_al{$Row_l}=1)  // Command
									$Result_t:=$Result_t+$Start_Span_1_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l}; $Start_al{$Row_l+1}-$Start_al{$Row_l}-$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=2)  // Function
									$Result_t:=$Result_t+$Start_Span_2_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l}; $Start_al{$Row_l+1}-$Start_al{$Row_l}-$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=3)  // String
									$Result_t:=$Result_t+$Start_Span_3_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l}; $Start_al{$Row_l+1}-$Start_al{$Row_l}-$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=4)  // Comment
									$Result_t:=$Result_t+$Start_Span_4_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l}; $Start_al{$Row_l+1}-$Start_al{$Row_l}-$Length_al{$Row_l})
									
								Else 
									
							End case 
							
						Else 
							Case of 
								: ($Type_al{$Row_l}=1)  // Command
									$Result_t:=$Result_t+$Start_Span_1_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=2)  // Function
									$Result_t:=$Result_t+$Start_Span_2_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=3)  // String
									$Result_t:=$Result_t+$Start_Span_3_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l})
									
								: ($Type_al{$Row_l}=4)  // Comment
									$Result_t:=$Result_t+$Start_Span_4_t+$Match_at{$Row_l}+$End_Span_t+Substring($SQL_t; $Start_al{$Row_l}+$Length_al{$Row_l})
									
								Else 
									
							End case 
					End case 
					
					Case of   // Lood ahead to see if the next start location is at or ahead of the current start location
						: ($Row_l=$Rows_l)  // If this is the last row
							$Start_al{0}:=0
							
						: (($Start_al{$Row_l}+$Length_al{$Row_l})>=$Start_al{$Row_l+1})  // If current location is at or ahead of the next location
							$Start_al{0}:=-1
							
						Else   // The next start location ahead of the current location
							$Start_al{0}:=1
					End case 
					
				End for 
				$Result_t:=Replace string($Result_t; Char(Carriage return); "<br/>")
				$Result_t:=$Header_t+$Result_t+$End_Span_t
				
				//OBJECT GET SCROLL POSITION(*;"SQL_Query_t";$rowPosition;$hPosition)
				//OBJECT GET SCROLLBAR(*;"SQL_Query_t";$horizontal;$vertical)
				//GET HIGHLIGHT(*;"SQL_Query_t";$startSel;$endSel)
				ST SET TEXT(*; "SQL_Query_t"; $Result_t)
				
				//HIGHLIGHT TEXT(*;"SQL_Query_t";1;1)
				HIGHLIGHT TEXT(*; "SQL_Query_t"; $Cursor_Start_l; $Cursor_End_l)  // Restore cursor position
				//OBJECT SET SCROLL POSITION(*;"SQL_Query_t";$rowPosition;$hPosition)
				//OBJECT SET SCROLLBAR(*;"SQL_Query_t";$horizontal;$vertical)
				
			Else   // Not one match found
				// Do nothing
			End if 
	End case 
	
Else   // Style SQL checkbox is unchecked
	// Do nothing
End if 
