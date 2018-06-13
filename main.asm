.include "header.inc"
.include "snesinit.asm"
.include "initdma.asm"

.bank 0 slot 0
.org $100

Start:
	jsr Init
	lda #0
	sta $2121	; use color 0
	lda #$FF
	sta $2122
	lda #$7F
	sta $2122	; set color 0 to white
	lda #$0F
	sta $2100	; 00001111 - the 4 LSB control brightness. max brightness

	jsr LoadPalette
	jsr LoadBo
loop:
	jmp loop

VBlank:
	rti
