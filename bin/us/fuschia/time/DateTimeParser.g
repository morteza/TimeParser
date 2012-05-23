grammar DateTimeParser;

//TODO 1. Time: <11y,spring,2mo,1w,1d,23h,2m,32s,12ms>	|	0t23h2m32s12ms
//TODO 2. Date: <march12,2001>	|	0dMarch12,2001
//TODO 3. variable 0txxxxxxxx or 0dxxxxxxxx

options {
  language = Java;
}

TIME_PHRASE:	START_TAG YEAR SEASON MONTH WEEK DAY HOUR MINUTE SECOND END_TAG;

//DONE (year: from 1985 to 2044)
YEAR		:	
				( '19' ( ('8' ('5'..'9')) | ('9' DIGIT) )
				| '20' ('0'..'3') DIGIT
				| '204' ('0'..'4') )
				('Y'|'y')
				;

//DONE (season:	spring,summer,autumn,fall,winter)
SEASON	:
				( 'spring' )
				| ( 'summer' ) 
				| ( 'autumn' )
				| ( 'fall' )
				| ( 'winter' )
				;

//DONE (month: from 1 to 12)
MONTH		:
				( ('0'? '1'..'9') 
				| ('1' ('0'..'2')) ) ( ('m' |'M') ( 'o' | 'O' ) )
				| MONTH_TEXTUAL
				;

//DONE
MONTH_TEXTUAL	:
				'j' ( ('an''uary'?) | ('une''e'?) | ('ul''y'?) )
				| 'a' ( ('pr''il'?) | ('ug''ust'?) )
				| 'm' ( ('ar''ch'?) | 'ay' )
				| ( 'feb''ruary'? )
				| ( 'sep''tember'? )
				| ( 'oct''ober'? )
				| ( ('nov'|'dec')'ember'? )
				;

//DONE (week: from 0 to 52)			
WEEK		:
				('0'..'4' DIGIT)
				| '5' ('0'..'2')
				;

//DONE (day: from 0 to 366)
DAY			:	
				('0'? DIGIT? DIGIT) 
				| ( '1' DIGIT DIGIT )
				| ( '2' DIGIT DIGIT )
				| '3' ( ('0'..'5' DIGIT) | ('6' ('0'..'6')) )
				;

//DONE (hour: from 0 to 24)		
HOUR		:
				( ('0'..'1')? DIGIT 
				| '2' ('0'..'4') ) ('h' | 'H')
				;

//DONE (minute: from 0 to 59)
MINUTE	:
				('0'..'5')? DIGIT	('m' | 'M')
				;

//DONE (second: from 0 to 59)
SECOND	:
				('0'..'5')? DIGIT	('s' | 'S')
				;

//DONE (digit: from 0 to 9)
DIGIT		:
				'0'..'9'
				;

//DONE
INTEGER	:	
				DIGIT+
				;

//DONE
NEWLINE	:
				'\r'? '\n'
				;

//DONE
COMMA		:
				','+ { $channel=HIDDEN; }
				;

//DONE
START_TAG	:
				'<'
				;

//DONE
END_TAG		:
				'>'
				;
				
//DONE
WS			:
				(' '|'\t')+ { $channel=HIDDEN; }
				;
