.globl mergeSort
.text
mergeSort:
	# Spara $ra och $a0, $a1 (behövs för att återgå korrekt)
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	# Kontrollera om size > 1
	ble $a1, 1, mergeSortEnd   # Om size <= 1, hoppa till slutet av funktionen
	
	# Beräkna half = size / 2
	srl $t0, $a1, 1            # t0 = half (size / 2)

	# Första rekursiva anropet: mergeSort(a, half)
	move $a0, $a0              # Första halvan börjar på samma pekare
	move $a1, $t0              # Anropa med size = half
	jal mergeSort              # Anropa mergeSort(a, half)

	# Andra rekursiva anropet: mergeSort(a + half, size - half)
	sll $t1, $t0, 2            # t1 = half * 4 (för att få rätt byte-offset i arrayen)
	add $a0, $a0, $t1          # a = a + half
	sub $a1, $a1, $t0          # a1 = size - half
	jal mergeSort              # Anropa mergeSort(a + half, size - half)

	# Anropa merge(a, size)
	lw $a0, 4($sp)             # Återställ arraypekaren
	lw $a1, 8($sp)             # Återställ storleken
	jal merge                  # Slå samman arrayen

mergeSortEnd:
	# Hämta tillbaka $ra och återställ stackpekaren
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

