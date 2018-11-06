	li $t1,1
	lw $t2,0($gp)#pega o valor de A na posição gp
	lw $t3,4($gp)#pega o valor de B na posição gp+4
	loop:
	slt $t4,$t3,$t2#1 se r3<r2(divisao inteira acabou)
	beq $t1,$t4,fim#se a divisao acabou pula para fim
	sub $t3,$t3,$t2#r3=r3-r2
	j loop
	fim:
	sw $t3, 8($gp)#salva o resto da divisao em 8+gp