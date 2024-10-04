	org 0h
begin:
	ld sp,27ffh
	ld a,89h
	out (cw),a
	ld hl,text1
	call disp_text1
	ld hl,text2
	call disp_text2
	call rand_8
	ld b,a
	ld hl,0
	ld c,100

divc:
	ld a,b
div_loop:
	cp c
	jr c,stopdiv
	sub c
	inc l
	jr div_loop
stopdiv:
	add a,c
	ld b,a
	call conv2ascii
	ld (rdec_num),a
	ld hl, rdec_num
	call disp_rnum
	ld c,10
	ld l,0
	jr divc
	ld a,b
	call conv2ascii
	ld (rdec_num),a
	ld hl, rdec_num
	call disp_rnum
	ret
disp_rnum:
	ld a,(hl)
	out (lcd),a
	inc hl
	jp divc
disp_text1:
	ld a,(hl)
	cp '&'
	jp z, end1
	out (lcd),a
	inc hl
	jp disp_text1
end1:
	ret
disp_text2:
	ld a,(hl)
	cp '&'
	jp z, end1
	out (lcd),a
	inc hl
	jp disp_text2
disp_qstn:
disp_text3:
	ld hl,text3
	ld a,(hl)
	cp '&'
	jp z, end1
	out (lcd),a
	inc hl
	jp disp_text2

	;rutina de numero aleatorio
rand_8:
	ld a,(r_seed)	; carga la semilla en A
	and #B8h		; mantiene los bits de no retorno
	scf			; activa carry
	jp PO,no_clr	; si es par salta el clear
	ccf			; complementa el acarreo (lo limpia)
no_clr:
	ld a,(r_seed)	; obtiene la semilla
	rla			; rota el carry en el byte
	ld (r_seed),a	; guarda la semilla para el siguiente numero aleatorio
	ret			; termina
conv2ascii:
	add a, 30h
	ret
	ld a,(hl)
	cp '&'
	jp z, end1
	out (lcd),a
	inc hl
	jp disp_text2
order:
	ld b,a
	ld d,0
	ld e,0
	ld l,0
	ld a,b
	cp 100
	jr c, centenas
	sub 100
	inc d
	jr order
centenas:
	cp 10
	jr c,decenas
	sub 10
	inc e
	jr centenas
decenas:
	ld l,a
	ld a,d
	cp e
	jr nc, noswapde
	ld a,d
	ld d,e
	ld e,a
noswapde:
	ld a,d
	cp l
	jr nc,noswapdl
	ld a,d
	ld d,l
	ld l,a
noswapdl:
	ld a,e
	cp l
	jr nc,noswapel
	ld a,e
	ld e,l
	ld l,a
noswapel:
	call disp_text3
	ld a,d
	ld (s_num),a
	ld hl,s_num
	call disp_rnum
	ld a,e
	ld (s_num),a
	ld hl,s_num
	call disp_rnum
	ld a,e
	ld (s_num),a
	ld hl,s_num
	call disp_rnum
	call another
	ret
another:
	in a,(keyb)
	cp 53h
	jp z, begin
	halt
	org 2000h ;segmento de varialbles
r_seed	.db	1		; semilla para el proceso de numero pseudo aleatorio
text1	.db "INICIANDO GENERADOR &"
text2	.db "NUMERO ALEATORIO: &"
text3	.db "NUMERO EN ORDEN NUMERICO: &"
qstn	.db "GENERAR NUEVO NUMERO ? S/N &"
ans	.db "  "
r_num	.db "  "
rdec_num	.db "   "
s_num	.db "   "
lcd	.equ 1h ;configuracion de puertos
keyb	.equ 2h
cw	.equ 3h
	.end