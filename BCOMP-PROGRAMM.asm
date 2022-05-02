	ORG 0x17F
BEGIN:                		CLA
NUM_INP:           	IN 7
                        		AND #0x40
                       		BEQ NUM_INP
                        		IN 6
                        		ST (CURSYMB)+
                        		LD (FIRSTSYMB)
                        		INC
                        		ST COUNTER
ITERATOR1:        	LOOP COUNTER
                        		JUMP INPUT
                        		JUMP PRE_OUTPUT
INPUT:                		IN 0x19
                        		AND #0x40
                        		BEQ INPUT
                        		IN 0x18
		CALL INPUT_CHECKER
                        		JUMP ITERATOR1
PRE_OUTPUT:    	LD (FIRSTSYMB)
                        		INC
                        		ST COUNTER
                        		LD FIRSTSYMB
                        		INC
                        		ST CURSYMB
ITERATOR2:        	LOOP COUNTER
                        		JUMP OUTPUT
                        		HLT
OUTPUT:            		CLA 
                   		CALL OUTPUT_CHECKER
					AND #0x0F
					ADD OFFSET
                        		OUT 0x14
					LD OFFSET
					ADD #0x10
					ST OFFSET
                        		JUMP ITERATOR2

INPUT_CHECKER:    	PUSH
        		LD COUNTER
        		AND #0x1
        		BEQ INPUT_SWAB
        		POP
        		ST (CURSYMB)
        		RET
INPUT_SWAB:    	POP
        		SWAB
        		ADD (CURSYMB)
        		ST (CURSYMB)+
        		RET

OUTPUT_CHECKER:   	LD COUNTER
        		AND #0x1
        		BEQ OUTPUT_SWAB
        		LD (CURSYMB)
		AND #0x7F
		CMP COND_MAX
		BPL CHANGE
		CMP COND_MIN
		BMI CHANGE
     		RET
OUTPUT_SWAB:   	LD (CURSYMB)+
        		SWAB
		AND #0x7F
		CMP COND_MAX
		BPL CHANGE
		CMP COND_MIN
		BMI CHANGE
        		RET

CHANGE:  		AND #0x00
		ADD COND_MAX
		RET
FIRSTSYMB:    		WORD 0x0610
CURSYMB:        		WORD 0x0610
COUNTER:        		WORD 0x0000
COND_MAX:            	WORD 0x003A
COND_MIN:		WORD 0x0030
OFFSET:			WORD 0x0000