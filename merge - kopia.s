.globl mergeBytUtMig
.text
mergeBytUtMig:
	subu $sp, $sp, 4		#  4 bytes f�r $ra
	sw $ra, 0($sp)			# $ra f�rsta

	# Argument:
	# argument 0 = addressen till f�rsta elementet i arrayen
	# argument 1 = storleken p� arrayen
	
	# t1 = half
	# t2 = i
	# t3 = j
	# t4 = k
	# t5 = b[]
	
	# int half = size / 2;
	addi $t8, $zero, 2
	div $a1, $t8
	mflo $t1
	
	# int i = 0
	addi $t2, $zero, 0
	
	# Skapa en kopia av a i b.
	jal copyArray
	
	# i = 0; (den har blivit modifierad av copyArray)
	addi $t2, $zero, 0
	# j = half
	addi $t3, $t1, 0
	# k = 0
	addi $t4, $zero, 0
	
	jal firstWhile
	jal secondWhile
	jal thirdWhile
	
    	lw $ra, 0($sp)            	# Restorera $ra
   	addi $sp, $sp, 4		# "Ta bort" all data p� stacken

   	jr $ra

firstWhile:
	# while (i < half && j < size) {}
	
	# $t6 = i < half
	# om $t6 = 1 s� �r kravet (i < half) uppfyllt
	sgt $t6, $t1, $t2
	addi $t7 , $t6, 0
	
	sgt $t6, $t3, $a1
	add $t7, $t7, $t6
	
	# $t7 �r resultatssiffran om den �r lika med 2 s� uppfyller alla kraven
	blt $t7, 2, end			# if(t7 < 2) { break; }
	
	# nu kommer vi in i loopen
	
	addi $t6, $t5, 0  # $t6 = pekare till b�rjan av b arrayen
	# Ta reda p� vad vi m�ste �ka $t6 med f�r att f� addressen till den siffran vi letar (p� i)
	# En word �r 4 bytes d�rf�r m�ste index i * 4
	addi $t7, $t2, 0  	# $t7 = i
	mul $t7, $t7, 4		# $t7 *= 4
	
	add $t6, $t6, $t7	# $t6 = $t6 + $t7
	lw $t7, 0($t6)		# $t7 = b[i]
	
	addi $t6, $t5, 0
	addi $t9, $t3, 0	# $t9 = j
	mul  $t9, $t9, 4	# $t9 *= 4
	add $t6, $t6, $t9
	
	lw $t8, 0($t6)		# $t8 = b[j]
	
	# if $t7 <= $t8
	bge $t8, $t7, firstWhileCondition1
	# else
	j firstWhileCondition1Else

firstWhileCondition1:	# if(b[i] <= b[j]) allts� om elementet p� h�ger sida �r st�rre �n elementet p� l�gre sida
	# a[k] = b[i];
	addi $t7, $a0, 0
	addi $t6, $t4, 0 	# $t6 = k
	mul $t6, $t6, 4		# $t6 = k * 4
	add $t7, $t7, $t6	# $t7 = pekare till a[k]
	
	addi $t8, $t5, 0
	addi $t6, $t2, 0	# $t6 = i
	mul $t6, $t6, 4		# $t6 = i * 4
	add $t8, $t8, $t6	# $t8 = pekare till b[i]

	lw $t6, 0($t7)		# $t6 = a[k]
	
	sw $t6, 0($t8)		# a[k] = b[i];
	
	# i++
	addi $t2, $t2, 1
	
	# k++
	addi $t4, $t4, 1
	
	# forts�tt loop
	j firstWhile

firstWhileCondition1Else: # om inte kravet "b[i] <= b[j]" uppfylls
	# a[k] = b[j];
	addi $t7, $a0, 0
	addi $t6, $t4, 0 	# $t6 = k
	mul $t6, $t6, 4		# $t6 = k * 4
	add $t7, $t7, $t6	# $t7 = pekare till a[k]
	
	addi $t8, $t5, 0
	addi $t6, $t3, 0	# $t6 = j
	mul $t6, $t6, 4		# $t6 = j * 4
	add $t8, $t8, $t6	# $t8 = pekare till b[j]
	
	sw $t6, 0($t8)		# a[k] = b[j];

	# j++
	addi $t3, $t3, 1

	# k++
	addi $t4, $t4, 1
	
	j firstWhile
	
secondWhile: 
	# while (i < half) {
	
	# if( i >= half ) break;
	bge $t2, $t1, end
	
	# Start av a[k] = b[i];
	addi $t7, $a0, 0
	addi $t6, $t4, 0 	# $t6 = k
	mul $t6, $t6, 4		# $t6 = k * 4
	add $t7, $t7, $t6	# $t7 = pekare till a[k]
	
	addi $t8, $t5, 0
	addi $t6, $t2, 0	# $t6 = i
	mul $t6, $t6, 4		# $t6 = i * 4
	add $t8, $t8, $t6	# $t8 = pekare till b[i]

	lw $t6, 0($t7)		# $t6 = a[k]
	
	sw $t6, 0($t8)		# a[k] = b[i];
	
	# i++;
	addi $t1, $t1, 1
	# k++;
	addi $t4, $t4, 1
	
	j secondWhile
	
thirdWhile:
	# while (j < size) {
	
	# if( j >= size ) break;
	bge $t3, $a1, end
	
	# a[k] = b[j];
	addi $t7, $a0, 0
	addi $t6, $t4, 0 	# $t6 = k
	mul $t6, $t6, 4		# $t6 = k * 4
	add $t7, $t7, $t6	# $t7 = pekare till a[k]
	
	addi $t8, $t5, 0
	addi $t6, $t3, 0	# $t6 = j
	mul $t6, $t6, 4		# $t6 = j * 4
	add $t8, $t8, $t6	# $t8 = pekare till b[j]
	
	sw $t6, 0($t8)		# a[k] = b[j];
	
	# j++
	addi $t3, $t3, 1
	
	# k++
	addi $t4, $t4, 1

copyArray:
	# for(i = 0;  i< size; i++)	- i finns p� $t2
	#	b[i] = a[i];
	
	bge $t2, $a1, endCopyArray	# G� ut ur loopen om vi �r klara 
	
	sll $t6, $t2, 2			# Address margin f�r nuvarande element
	add $t7, $a0, $t6		# Address + address margin f�r att f� det element vi vill ha
	lw  $t8, 0($t7)			# $t8 = a[i];
	
    	add $t9, $t5, $t6         	# Destination address = base + (i * 4)
  	sw  $t8, 0($t9)           	# L�gg v�rdet i $t8 i destinationsaddressen
	
	
	addi $t2, $t2, 1		# i++
	
	j copyArray

endCopyArray:
	addi $t6, $zero, 0
	addi $t7, $zero, 0
	addi $t8, $zero, 0
	addi $t9, $zero, 0

	j end	

end:
	jr $ra
