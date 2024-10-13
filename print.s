	.globl print
print:
	sw	$a0, 0($sp)		#store a-registers on stack
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)		#a0 = address to substring to be printed
	move 	$t0, $a0		#t0 = current address
	addi	$t1, $zero, 4		#t1 = parameter numbering * 4
	lb	$t2, 0($t0)		#t2 = character in current address
while:
	beq 	$t2, '\0', endWhile	#end of format string
	beq	$t2, '%', if		#check for format specifiers (%)
	addi 	$t0, $t0, 1
	j	endif
if:
	lb	$t3, 1($t0)		#check for the three allowed format specifiers
	beq	$t3, 'd', if2
	beq	$t3, 's', if2
	beq	$t3, 'c', if2
	addi 	$t0, $t0, 1
	j	endif
if2:	
	addi	$t4, $zero, '\0'	#replace '%' by '\0' in preparation for printing
	sb	$t4, 0($t0)
	addi	$v0, $zero, 4		#system call, print string
	syscall
	addi	$t4, $zero, '%'		#restore '%' in format string
	sb	$t4, 0($t0)
	beq	$t3, 'c', c		#check type of specifier
	beq	$t3, 's', s
d:	addi	$v0, $zero, 1		#system call, print integer
	j	dsc	
s:	addi	$v0, $zero, 4		#system call, print string
	j	dsc
c:	addi	$v0, $zero, 11		#system call, print character	
dsc:	move 	$t4, $a0		#store a0 temporarily
	add	$a0, $sp, $t1		#fetch parameter
	lw	$a0, 0($a0)
	syscall
	move	$a0, $t4		#restore a0
	addi	$a0, $t0, 2		#next substring to be printed
	addi	$t1, $t1, 4		#move parameter offset four steps forward 
	move	$t0, $a0		#move current address
endif:	
	lb	$t2, 0($t0)		#next character in the format string 
	j 	while
endWhile:
	addi	$v0, $zero, 4		#system call, print string (address in a0)
	syscall
	addi	$v1, $zero, 0xffff      #put garabage in remaining v, a and t registers
	addi	$a0, $zero, 0xffff
	addi	$a1, $zero, 0xffff
	addi	$a2, $zero, 0xffff
	addi	$a3, $zero, 0xffff
	addi	$t3, $zero, 0xffff
	addi	$t4, $zero, 0xffff
	addi	$t5, $zero, 0xffff
	addi	$t6, $zero, 0xffff
	addi	$t7, $zero, 0xffff
	addi	$t8, $zero, 0xffff
	addi	$t9, $zero, 0xffff
	jr 	$ra
