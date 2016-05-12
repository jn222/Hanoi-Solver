.data 0x0
	welcome: .asciiz "Welcome to the Tower of Hanoi Puzzle Solver.\nEnter the number of disks in the scenario.\n"
	done: .asciiz "Done. Is there another Tower of Hanoi Puzzle you wish to compute?\nEnter (1) for yes and (0) to quit.\n"
	move1: .asciiz "Move disk "
	move2: .asciiz " from peg "
	move3: .asciiz " to peg "
	move4: .asciiz ".\n"
	csource: .asciiz "A"
	cdest: .asciiz "C"
	cspare: .asciiz "B"
	
.text 0x3000
.globl main

main:

do:
	la $a0, welcome
	ori $v0, $0, 4
	syscall
	ori $v0, $0, 5
	syscall
	ori $s0, $v0, 0
	mul $a0, $s0, 4
	ori $v0, $0, 9
	syscall
	ori $t0, $0, 0

populate:
	beq $t0, $s0, arrays
	mul $t1, $t0, 4
	addi $t2, $t0, 1
	add $a1, $t1, $v0
	sw $t2, ($a1)
	addi $t0, $t0, 1
	j populate
	
arrays:
	ori $a1, $v0, 0
	ori $v0, $0, 9
	syscall
	add $a2, $v0, $t1
	ori $v0, $0, 9
	syscall
	add $a3, $v0, $t1
	ori $a0, $s0, 0

	addi $sp, $sp, -12
	la $t0, csource
	sw $t0, 8($sp)
	la $t0, cdest
	sw $t0, 4($sp)
	la $t0, cspare
	sw $t0, 0($sp)
	jal hanoi
	addi $sp, $sp, 12
	
	la $a0, done
	ori $v0, $0, 4
	syscall
	ori $v0, $0, 5
	syscall
	beq $v0, 1, do
	
exit:
	ori $v0, $0, 10
	syscall
	
hanoi:
	addi $sp, $sp, -8
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 4
	
	add $sp, $sp, -28
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	
	ori $s0, $a0, 0
	ori $s1, $a1, 0
	ori $s2, $a2, 0
	ori $s3, $a3, 0
	
	lw $s4, 12($fp)
	lw $s5, 8($fp)
	lw $s6, 4($fp)
	
	bne $a0, 1, else
	
	ori $a0, $s0, 0
	ori $a1, $s1, 0
	ori $a2, $s2, 0
	ori $a3, $s4, 0
	addi $sp, $sp, -4
	sw $s5, 0($sp)
	jal hmove
	addi $sp, $sp, 4
	
	j hreturn
	
else:
	add $a0, $s0, -1
	ori $a1, $s1, 0
	ori $a2, $s3, 0
	ori $a3, $s2, 0
	addi $sp, $sp, -12
	sw $s4, 8($sp)
	sw $s6, 4($sp)
	sw $s5, 0($sp)
	jal hanoi
	addi $sp, $sp, 12

	ori $a0, $s0, 0
	ori $a1, $s1, 0
	ori $a2, $s2, 0
	ori $a3, $s4, 0
	addi $sp, $sp, -4
	sw $s5, 0($sp)
	jal hmove
	addi $sp, $sp, 4

	add $a0, $s0, -1
	ori $a1, $s3, 0
	ori $a2, $s2, 0
	ori $a3, $s1, 0
	addi $sp, $sp, -12
	sw $s6, 8($sp)
	sw $s5, 4($sp)
	sw $s4, 0($sp)
	jal hanoi
	addi $sp, $sp, 12
	
hreturn:
	lw $s0, -8($fp)
	lw $s1, -12($fp)
	lw $s2, -16($fp)
	lw $s3, -20($fp)
	lw $s4, -24($fp)
	lw $s5, -28($fp)
	lw $s6, -32($fp)
	lw $ra, 0($fp)
	lw $fp, -4($fp)
	addiu $sp, $sp, 36
	jr $ra
	
hmove:
	lw $t0, ($a1)
	sw $t0, ($a2)
	addi $a2, $a2, -4
	sw $0, ($a1)
	addi $a1, $a1, 4
	ori $t0, $a0, 0
	ori $v0, $0, 4
	la $a0, move1
	syscall
	ori $a0, $t0, 0
	ori $v0, $0, 1
	syscall
	la $a0, move2
	ori $v0, $0, 4
	syscall
	ori $a0, $a3, 0
	syscall
	la $a0, move3
	syscall
	lw $a0, 0($sp)
	syscall	
	la $a0, move4
	syscall
	jr $ra
	