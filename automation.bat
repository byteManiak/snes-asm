@echo off
wla-65816 -o main.obj main.asm
wlalink -r main.link game.smc
