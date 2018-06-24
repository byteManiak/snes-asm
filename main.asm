.include "header.inc"
.include "snesinit.asm"
.include "initdma.asm"
.include "controls.asm"
.include "ball.asm"
.include "sprites/spriteCols.inc"
.include "sprites/sprites.inc"

.bank 0 slot 0
.org $F9

Start:
	Snes_Init
	;lda #$0F
	;sta $2100	; 00001111 - the 4 LSB control brightness. max brightness
	stz $2105
	stz $2107
	lda #$81
	sta $4200
	LoadPalette spriteCols, 128, 32
	LoadSprites sprites, $0000, 2048
	jsr InitOAM

	lda #%10100000	; Use small 32x32 and large 64x64 sprites
	sta $2101

	lda #%00010000	; Enable sprites layer
	sta $212C

loop:
	jmp loop

VBlank:
	jsr leftPaddle
	jsr rightPaddle
	jsr ingameDMA	
	lda $4210
	rti
