	.data 

initialPrompt: .asciiz "I'm thinking of a number between 0 and 50, see if you can guess in less than 5 tries...\n"
tooLowPrompt: .asciiz "Your guess is too low...\n"
tooHighPrompt: .asciiz "Your guess is too high...\n"	
successPrompt: .asciiz "Guess is correct, you win! Initiating skynet bootup...\n"
failPrompt: .asciiz "Out of attempts, the machines win again you petty human!\n"
tries: .word 200
	
.globl main	
	
	
	.text

#s0 = number to guess
#s1 = user input guess
#s2 = attempts limit (5)
#s3 = attempts
#s4 = rand int seed

main:
	
	jal initRandNum
	move $s0, $a0
	
	jal welcome
	
gameLoop:
	
	beq $s2, $s3, stateFailure
	jal getInput
	move $s1, $v0
	
	beq $s1, $s0, stateSuccess
	bgt $s1, $s0, stateHigh
	blt $s1, $s0, stateLow
	 
	continueGame:
	addi $s3, $s3, 1
	j gameLoop
	
	li $v0, 10
	syscall
	
	
####### Procedures #########

initRandNum:
	li $v0, 30
	syscall
	
	li $v0, 42
	la $a1, 50
	syscall
	jr $ra

welcome:
	li $v0, 4
	la $a0, initialPrompt
	syscall
	lw $s2, tries
	li $s3, 0
	jr $ra


getInput:
	li $v0, 5
	syscall
	jr $ra

stateHigh:
	li $v0, 4
	la $a0, tooHighPrompt
	syscall
	j continueGame
	
stateLow:
	li $v0, 4
	la $a0, tooLowPrompt
	syscall
	j continueGame
	
stateSuccess:
	li $v0, 4
	la $a0, successPrompt
	syscall
	j exit


stateFailure:
	li $v0, 4
	la $a0, failPrompt
	syscall
	j exit


printNewline:


exit:
	li $v0, 10
	syscall	
