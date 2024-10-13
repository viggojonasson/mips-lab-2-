.data
	print_int: .asciiz "%d "
	newline: .asciiz "\n"

.globl printArray
.text
printArray:
	subu $sp, $sp, 16		# 16 bytes, 4 för $ra, 12 för spara nuvarande $s0-$s2 register
	sw $ra, 0($sp)			# $ra första
	
	# Argument:
	# argument 0 = addressen till första elementet i arrayen
	# argument 1 = storleken på arrayen
	# Lägg dom i $s0, $s1 och index i $s2, men först spara dessa tre register så vi kan återställa dom sedan
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	la $s0, ($a0)			# $s0 = addressen till första arrayen i elementet
	addi $s1, $a1, 0		# $s1 = storleken på arrayen
	addi $s2, $zero, 0		# $s2 = index på arrayen
	
	
	# Printa första newlinen
	subu $sp, $sp, 16
	la $a0, newline
	jal print
	addi $sp, $sp, 16
	
	jal doPrint
	
	# Printa systa newlinen
	subu $sp, $sp, 16
	la $a0, newline
	jal print
	addi $sp, $sp, 16
	
	# Cleanup
    	lw $ra, 0($sp)            	# Restore $ra
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
   	addi $sp, $sp, 16		# "Ta bort" all data på stacken

   	 # Return to the caller
   	jr $ra                    	# Jump back to the return address

doPrint:
	subu $sp, $sp, 4 		# Spara nuvarande return address på stacken för mainLoop ska komma tillbaka
	sw $ra, 0($sp)
	
	j mainLoop
	

mainLoop:
	# Är index vid slutet av arrayen, avsluta då.
	beq $s1, $s2, exitLoop
	
	subu $sp, $sp, 16
	la $a0, print_int
	lb $a1, 0($s0) # $a1 = element att printa
	jal print
	addi $sp, $sp, 16
	
	addi $s0, $s0, 4		# inkrementa pekaren till nästa int, 4 bytes för 1 int
	addi $s2, $s2, 1		# inkrementa index

	j mainLoop
	
exitLoop:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra