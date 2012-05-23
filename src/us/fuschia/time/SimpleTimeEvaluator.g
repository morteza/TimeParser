grammar SimpleTimeEvaluator;

//Example: t2w,3d,23h,2m,32s,12ms


options {
  language = Java;
}

header {	
	import java.util.HashMap;
}

members {
	/** Map variable name to Integer object holding value */
	HashMap memory = new HashMap();
}

app:
		stat+
		;
            
stat:   expr NEWLINE {System.out.println($expr.value);}
    |   ID '=' expr NEWLINE
        {memory.put($ID.text, new Integer($expr.value));}
    |   NEWLINE
    ;

expr returns [int value]
    :   e=multExpr {$value = $e.value;}
        (   '+' e=multExpr {$value += $e.value;}
        |   '-' e=multExpr {$value -= $e.value;}
        )*
    ;

multExpr returns [int value]
    :   e=atom {$value = $e.value;} ('*' e=atom {$value *= $e.value;})*
    ; 

atom returns [int value]
    :   t=TIME {$value = $t.value;}
    |   ID
        {
        	Integer v = (Integer)memory.get($ID.text);
        	if ( v!=null ) $value = v.intValue();
        	else System.err.println("undefined time variable: "+$ID.text);
        }
    |   '(' e=expr ')'
    		{
    			$value = $e.value;
    		}
    ;

ID
		:
		('a'..'z'|'A'..'Z')+
		;

TIME returns [int value]
		:(
		START_TAG (w=WEEKS)? (d=DAYS)? (h=HOURS)? (m=MINUTES)? (s=SECONDS)? (ms=MILLISECONDS)?
		{
			$value = $w.value + $d.value + $h.value + $m.value + $s.value + $ms.value ;
		})
		;

WEEKS returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text) * 1000 * 60 * 60 * 24 * 7; } ('w'|'W')
		;

DAYS returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text) * 1000 * 60 * 60 * 24; } ('d'|'D')
		;

HOURS returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text) * 1000 * 60 * 60; } ('h'|'H')
		;

MINUTES returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text) * 1000 * 60; } ('m'|'M')
		;

/**
* Seconds' rule in time grammer
*/
SECONDS returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text) * 1000; } ('s'|'S')
		;

MILLISECONDS returns [int value]
		:
		INTEGER { $value = Integer.parseInt($INTEGER.text); } ('ms'|'MS'|'Ms'|'mS')
		;

DIGIT
		:
		'0'..'9'
		;

INTEGER
		:	
		DIGIT DIGIT*
		;

NEWLINE
		:
		'\r'? '\n'
		;

fragment START_TAG	:
				'0t'
				;
				
WS			:
				(' '|'\t')+ { $channel = HIDDEN; }
				;
