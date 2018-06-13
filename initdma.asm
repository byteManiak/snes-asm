.include "sprites/boCols.inc"
.include "sprites/boSprite.inc"

.bank 0 slot 0
.org $140

LoadPalette:
	phb
	php

	lda #<boCols
	sta $4302
	lda #>boCols
	sta $4303
	lda #:boCols
	sta $4304	; Set DMA source address and bank
	
	lda #32
	sta $4305	; Set transfer size to 32B
	stz $4306
	stz $4300	; Set transfer mode to 1-byte
	
	lda #128
	sta $2121	; Set current color to 128 - where sprite colors begin

	lda #$22
	sta $4301	; Set DMA destination to $2122

	lda #1
	sta $420B	; Begin DMA transfer

	plp
	plb
	rts

LoadBo:
	phb
	php
	lda #<boSprite
	sta $4302
	lda #>boSprite
	sta $4303
	lda #:boSprite
	sta $4304	; Set DMA source address and bank

	stz $4305
	lda #8
	sta $4306	; Set transfer size to 2kB

	lda #1
	sta $4300	; Set transfer mode to 1-word

	lda #$18
	sta $4301	; Set DMA destination to $2118

	lda #$80
	sta $2115	; Increase VRAM address when writing to $2119

	stz $2116
	stz $2117	; Set VRAM destination address

	lda #2
	sta $420B	; Begin DMA transfer

	plp
	plb
	rts
