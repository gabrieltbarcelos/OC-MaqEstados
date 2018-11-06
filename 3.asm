	li r0,0
	li $t1,1
	li $t6,0
	lw $t2,0($gp)#pega o valor de A na posição gp
	lw $t3,4($gp)#pega o valor de B na posição gp+4
	slti $t4,$t2,0# 1 se a negativo 0 se a positivo 
	beq $t4,$t0,negativo;

	positivo:
		beq $t2,$t0,fim#se acabou de multiplicar vai para fim
		add $t6,$t6,$t3#incrementa r6(soma) de r3(B)
		subi $t2,$t2,1#decrementa r2 de 1
	j positivo;
	
	negativo:
		beq $t2,$t0,fim#se acabou de multiplicar vai para fim
		sub $t6,$t6,$t3#decrementa r6(soma) de r3(B)
		addi $t2,$t2,1#incrementa r2 de 1	
	j negativo;
	
	fim:
	sw $t6,8($gp)#salva o produto na posição gp+8
	