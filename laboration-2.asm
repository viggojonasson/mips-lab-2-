.data
	# Antagande: �ven fast vi skulle kunnat komma undan med att anv�nda .byte h�r s� anv�nder vi .word eftersom c koden anv�nder "int".
	antal: .word 10
	vek: .word 4,5,2,2,1,6,7,9,5,10


.globl main
.text
main:
	la $a0, vek
	lw $a1, antal
	
	jal printArray
	
	la $a0, vek
	lw $a1, antal
	
	jal mergeSort
	# jal merge
	
	la $a0, vek
	lw $a1, antal
	
	jal printArray

	j exit
exit:
	li $v0, 10
	syscall
