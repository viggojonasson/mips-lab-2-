.globl merge
.text
merge:
	# Spara $ra
   	addi $sp, $sp, -4
    	sw $ra, 0($sp)

	srl $t1, $a1, 1			# t3 = half (int half = size / 2)
	
	jal cpyArray			# skapa en kopia av arrayen som vi l�gger p� stacken
	
	# Variabler:
	# a0 = pekare till arrayen
	# a1 = storleken p� arrayen
	# t1 = half
	# t2 = i
	# t3 = j
	# t4 = k

	move $t3, $t1			# j = half
	move $t4, $zero			# k = 0
	
	jal firstLoop
	jal secondLoop
	jal thirdLoop
	
	jal clearArrayCpy		# vi �r klara med array kopian, ta bort fr�n stacken

	# Klara med merge, h�mta ut $ra igen
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

firstLoop:
	# Kontrollera om (i < half && j < size)
	blt $t2, $t1, firstLoopCheckJ   # Om i (t2) < half (t1), kontrollera j
	j breakLoop                	# Annars bryt loopen

firstLoopCheckJ:
	blt $t3, $a1, firstLoopBody     # Om j (t3) < size (a1), forts�tt till loopBody
	j breakLoop                	# Annars bryt loopen

firstLoopBody:
	# H�mta v�rdet b[i]
	move $t7, $t2            	# Kopiera i till t7
	sll $t7, $t7, 2          	# t7 = i * 4 (multiplicera index i med 4 f�r att f� offset)
	add $t8, $sp, $t7        	# t8 = &b[i] (h�mta adressen f�r b[i] p� stacken)
	lw $t9, 0($t8)           	# t9 = b[i] (l�s v�rdet av b[i])

	# H�mta v�rdet b[j]
	move $t7, $t3            	# Kopiera j till t7
	sll $t7, $t7, 2          	# t7 = j * 4 (multiplicera index j med 4 f�r att f� offset)
	add $t8, $sp, $t7        	# t8 = &b[j] (h�mta adressen f�r b[j] p� stacken)
	lw $t6, 0($t8)          	# t6 = b[j] (l�s v�rdet av b[j])

	# Kontrollera om b[i] <= b[j]
	ble $t9, $t6, firstLoopCopyI   # Om b[i] <= b[j], g� till copyI
	# Annars kopiera b[j] till a[k]
    
	# a[k] = b[j]
	sll $t7, $t4, 2          	# t7 = k * 4 (multiplicera index k med 4 f�r att f� offset)
	add $t8, $a0, $t7        	# t8 = &a[k] (h�mta adressen f�r a[k])
	sw $t6, 0($t8)          	# a[k] = b[j]
	addi $t3, $t3, 1         	# j++

	j firstLoopIncrementK		# G� till n�sta steg
	
firstLoopCopyI:
	# a[k] = b[i]
	sll $t7, $t4, 2          	# t7 = k * 4 (multiplicera index k med 4 f�r att f� offset)
	add $t8, $a0, $t7        	# t8 = &a[k] (h�mta adressen f�r a[k])
	sw $t9, 0($t8)           	# a[k] = b[i]
	addi $t2, $t2, 1        	# i++
	
firstLoopIncrementK:
	addi $t4, $t4, 1         	# k++
	j firstLoop              	# G� tillbaka till loopen
    	
secondLoop:
	# while (i < half)
	blt $t2, $t1, secondLoopBody   # Om i (t2) < half (t1), forts�tt till loopBody
	j breakLoop                	# Annars bryt loopen
secondLoopBody:
	# a[k] = b[i]
	sll $t7, $t2, 2          	# t7 = i * 4 (multiplicera index i med 4 f�r att f� offset)
	add $t8, $sp, $t7        	# t8 = &b[i] (h�mta adressen f�r b[i] p� stacken)
	lw $t9, 0($t8)           	# t9 = b[i] (l�s v�rdet av b[i])
	
	sll $t7, $t4, 2          	# t7 = k * 4 (multiplicera index k med 4 f�r att f� offset)
	add $t8, $a0, $t7        	# t8 = &a[k] (h�mta adressen f�r a[k])
	sw $t9, 0($t8)           	# a[k] = b[i]
	
	addi $t2, $t2, 1         	# i++
	addi $t4, $t4, 1         	# k++
	
	j secondLoop             	# G� tillbaka till loopen
	
thirdLoop:
	# while (j < size) {
	blt $t3, $a1, thirdLoopBody   # Om j (t3) < size (a1), forts�tt till loopBody
	j breakLoop                	# Annars bryt loopen

thirdLoopBody:
	# a[k] = b[j]
	sll $t7, $t3, 2          	# t7 = j * 4 (multiplicera index j med 4 f�r att f� offset)
	add $t8, $sp, $t7        	# t8 = &b[j] (h�mta adressen f�r b[j] p� stacken)
	lw $t9, 0($t8)           	# t9 = b[j] (l�s v�rdet av b[j])
	
	sll $t7, $t4, 2          	# t7 = k * 4 (multiplicera index k med 4 f�r att f� offset)
	add $t8, $a0, $t7        	# t8 = &a[k] (h�mta adressen f�r a[k])
	sw $t9, 0($t8)           	# a[k] = b[j]
	
	addi $t3, $t3, 1         	# j++
	addi $t4, $t4, 1         	# k++
	
	j thirdLoop              	# G� tillbaka till loopen

breakLoop:
	# Cleanup
	move $t5, $zero
	move $t6, $zero
	move $t7, $zero
	move $t8, $zero
	move $t9, $zero

	jr $ra
	
cpyArray:
	move $t2, $zero 		# t2 = i, vi s�tter i till 0
cpyArrayLoop:
	bge $t2, $a1, cpyArrayEnd	# if i >= size { break }
	
	addi $sp, $sp, -4		# minska stackpointer med 4 f�r att f� plats med en int
	
	move $t5, $t2			# Kopiera nuvarande index till t5
	sll $t5, $t5, 2			# t5 = i * 4 (skiftar v�nster f�r att multiplicera med 4)
	
	add $t6, $a0, $t5        	# t6 = a + (i * 4), detta �r adressen f�r a[i]
	lw $t7, 0($t6)           	# L�s in v�rdet av a[i] till t7
	
	sw $t7, 0($sp)           	# Spara v�rdet p� stacken
	
	addi $t2, $t2, 1         	# i++
	
	j cpyArrayLoop           	# Loop tillbaka till b�rjan
	
cpyArrayEnd:
	move $t2, $zero			# t2 = 0, �terst�ll i till 0 eftersom vi modifierat den
	jr $ra
	
clearArrayCpy:
	# �terst�ll stackpekaren efter kopiering
	mul $t5, $a1, 4        # t5 = size * 4 (totala minnesutrymmet som anv�ndes f�r arrayen)
	add $sp, $sp, $t5      # �terst�ll stackpekaren till d�r $ra �r sparad
	
	jr $ra
	
