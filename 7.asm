#o tamanho do vetor esta na pos 100 e o vetor esta na 200 de 4 em 4 bytes
#o elemento a ser proucurado no vetor esta em 104;
#a soma sera salva em 108
	
	li $t0,0
	li $t5,0#usarei de iterador
	li $t7,0#somatorio de qntas copias tem
	li $t1,100
	lw $t2,0($t1)#r2 recebe o tamanho do vetor
	lw $t3,4($t1)#r3 recebe o elemento a ser proucurado
	loop:
		beq $t2,$t0,fim
		lw $t6,200($t5)#r6 recebe a posição corrente do vetor
		subi $t2,$t2,1#decrementa o tamanho do vetor
		addi $t5,$t5,4#avança uma posiçao no vetor
		beq $t6,$t3,igual#se achou um igual vai para igual
	j loop:
	igual:
		addi $t7,$t7,1#incrementa copias
		j loop#volta pra loop
	fim:
		sw $t7,8($t1)#salva resultado em 108