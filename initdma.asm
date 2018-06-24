.bank 0 slot 0
.org $200

.macro LoadPalette
	lda #\2
	sta $2121
	ldx #\1
	lda #:\1
	ldy #\3
	jsr LoadPaletteRoutine
.endm

LoadPaletteRoutine:
	php

	stx $4302
	sta $4304	; Set DMA source address and bank
	
	sty $4305	; Set transfer size
	
	stz $4300	; Set transfer mode to 1-byte
	
	lda #$22
	sta $4301	; Set DMA destination to $2122

	lda #1
	sta $420B	; Begin DMA transfer

	plp
	rts

.macro LoadSprites
	lda #$80
	sta $2115	; Increment VRAM address when writing to $2119.
	sta $2100	; Turn off screen to force VBlank.
	ldx #\2
	stx $2116	; Set initial VRAM address.
	lda #:\1
	ldx #\1
	ldy #\3
	jsr LoadSpritesRoutine
	lda #$0F
	sta $2100	; Turn screen back on.
.endm

LoadSpritesRoutine:
	php

	stx $4302
	sta $4304	; Set DMA source address and bank

	sty $4305	; Set DMA transfer size in bytes
	
	lda #1
	sta $4300	; Set transfer mode to 1-word

	lda #$18
	sta $4301	; Set DMA destination to $2118

	lda #1
	sta $420B	; Begin DMA transfer

	plp
	rts

InitOAM:
	php

	rep #$10
	sep #$20

	ldx #$0000
	lda #$01
-	sta $0000, X
	inx
	stz $0000, X
	inx
	stz $0000, X
	inx
	stz $0000, X
	inx
	cpx #$0200
	bne -		; Fill OAM copy with sprite coords, flip, tileset, palette

-	lda #$55
	sta $0000, X
	inx
	cpx #$0220
	bne -		; Fill last 32B of OAM copy with X MSB and large/small size

	lda #112
	sta $0000	; Set X coord of first sprite
	lda #96
	sta $0001	; Set Y coord of first sprite
	stz $0200	
	lda #%01010100
	sta $0201	; Enable first 5 sprites

	stz $0004
	stz $0008	; Set X coord of left paddle top and bottom
	lda #80
	sta $0005
	lda #112
	sta $0009	; Set Y coord of left paddle top and bottom
	lda #4
	sta $0006
	sta $000A	; Set sprites for the left paddle

	lda #224
	sta $000C
	sta $0010	; Set X coord of right paddle top and bottom
	lda #80
	sta $000D
	lda #112
	sta $0011	; Set Y coord of right paddle top and bottom
	lda #4
	sta $000E
	sta $0012	; Set sprites for the left paddle
	lda #$40
	sta $000F
	sta $0013

	stz $4302
	stz $4303
	lda #$7e
	sta $4304	; Set DMA source address and bank

	ldx #$0220
	stx $4305	; Set DMA transfer size

	stz $4300	; Set DMA transfer mode to 1-byte

	stz $2102
	stz $2103	; Set OAM address to 0

	lda #4
	sta $4301	; Set DMA destination to $2104

	lda #1
	sta $420b	; Begin DMA transfer

	plp
	rts

ingameDMA:
	php

	stz $4302
	stz $4303
	lda #$7e
	sta $4304

	ldx #$0014
	stx $4305

	stz $4300

	stz $2102
	stz $2103

	lda #4
	sta $4301

	lda #1
	sta $420b

	plp
	rts
