

li $t0, 0
li $t3, 0
li $t4, 1
loop: beq $t4, $t0, fim
	lw $t4, 0($gp)
	lw $t5, 24($gp)
	sub $t3, $t4, $t5
	sw $t3, 0($gp)
	addi $gp, $gp, 4
	j loop
fim: nop