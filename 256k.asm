;masachuset
	org $2000
inicio
	jsr limpioval
	lda #80
	sta 710
	jsr buscomemoria
pantalla
	lda #<pantalla.dli
	sta $230
	lda #>pantalla.dli
	sta $231
muestrobancos
	ldy bancos
	sty val
	jsr bin2bcd
	lda res_atascii+7
	sta totbancos+1
	lda res_atascii+6
	sta totbancos
	jsr limpioval
	ldx #1
;calculamos la cantidad de bytes totales
;canbytes
cantidadbytes
	clc
	lda val
	adc bybancos
	sta val
	lda val+1
	adc bybancos+1
	sta val+1
	lda val+2
	adc bybancos+2
	sta val+2
	cpx bancos
	beq muestrocantidaddebytes
	inx
	jmp cantidadbytes
muestrocantidaddebytes
	jsr bin2bcd
	lda res_atascii+7
	sta totmemoria+5
	lda res_atascii+6
	sta totmemoria+4
	lda res_atascii+5
	sta totmemoria+3
	lda res_atascii+4
	sta totmemoria+2
	lda res_atascii+3
	sta totmemoria+1
	lda res_atascii+2
	sta totmemoria
loop
	jmp loop
buscomemoria
	ldy #max
busco01
	lda b,y
	sta 54017
	sta 22222
	dey
	bpl busco01
	ldy #1
busco02
	lda b,y
	sta 54017
	cmp 22222
	bne distinto
	iny
	cpy #max+1
	bne busco02
distinto
	sty bancos
	lda #171
	sta 54017
	rts
pantalla.dli
	.byte $70,$70,$70,$42
	.word pantalla.data
	.byte $02,$02,$02,$02,$02,$02
	.byte $41
	.word pantalla.dli
; Convert an 16 bit binary value into a 24bit BCD value
limpioval
	ldx #0
	stx val
	stx val+1
	stx val+2
	rts
res_atascii
	.byte $00,$00,$00,$00,$00,$00,$00,$00
res_bcd
	.byte $00,$00,$00,$00
val
	.byte $00,$00,$00
bin2bcd
	lda #0        	;Clear the result area
	sta res_bcd+0
	sta res_bcd+1
	sta res_bcd+2
	sta res_bcd+3
	ldx #24       	;Setup the bit counter
	sed           	;Enter decimal mode
_loop	asl val+0     	;Shift a bit out of the binary
	rol val+1
	rol val+2     	;... value
	lda res_bcd+0 	;And add it into the result, doubling
	adc res_bcd+0
	sta res_bcd+0
	lda res_bcd+1 
	adc res_bcd+1 
	sta res_bcd+1 
	lda res_bcd+2 
	adc res_bcd+2 
	sta res_bcd+2 
	lda res_bcd+3 
	adc res_bcd+3 
	sta res_bcd+3
	dex           	;More bits to process?
	bne _loop     
	cld           	;Leave decimal mode
			;BRK
bcd2atascii                       
	ldx #4        
	ldy #0 
_loop2                       
	lda res_bcd-1,X
	lsr           
	lsr           
	lsr           
	lsr           
	ora #$10 
	sta res_atascii,Y
	lda res_bcd-1,X
	and #$0f     
	ora #$10     
	sta res_atascii+1,Y
	iny           
	iny           
	dex           
	bne _loop2    
	rts     
;data
max = 16
B  	.byte 177,161,165,169,173,193,197,201
	.byte 205,225,229,233,237,129,133,137
	.byte 141
bancos
	.byte $00
canbytes
	.byte $00,$00,$00
bybancos
	.byte $00,$40,$00
pantalla.data
	.sb +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
	.sb "|     Reconocedor de bancos atari.     |"
	.sb +32,"ARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRD"
	.sb "|Bancos dispo. "
totbancos
	.sb "00"
pantalla.data01
	.sb "    Memo dispo. "
totmemoria	
	.sb "000000"
pantalla.data02
	.sb "|"
	.sb +32,"ARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRD"
	.sb "|           by Dogdark 2019            |"
	.sb +32,"ZRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRC"
	*=$2e0
	run inicio