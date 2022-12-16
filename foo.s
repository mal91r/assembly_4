	.intel_syntax noprefix			# 

	.text					# начинает секцию
	.section	.rodata
	.align 8

.LC0:						# "Повар приготовил еще %d кусков.\n"
	.string	"\320\237\320\276\320\262\320\260\321\200 \320\277\321\200\320\270\320\263\320\276\321\202\320\276\320\262\320\270\320\273 \320\265\321\211\320\265 %d \320\272\321\203\321\201\320\272\320\276\320\262.\n"
	.text
	.globl	threadFunc
	.type	threadFunc, @function

threadFunc:
	push	rbp				# сохраняем rbp на стек
	mov	rbp, rsp			# rbp := rsp
	sub	rsp, 32				# rsp -= 32
	mov	r12, rdi			# rbp[-24] := thread_data 
	mov	rax, r12			# rax := *thread_data
	mov	r13, rax			# rbp[-8] := *thread_data
	mov	rax, r13			# m := *thread_data
	lea	rdx, 4[rax]			# rdx := (m+1)
	mov	rax, r13			# rax := m
	mov     eax, DWORD PTR [rax]            # eax := *m
        mov     DWORD PTR [rdx], eax            # *(m+1) := *m
	mov	rax, r13			# rax := m
	mov	eax, DWORD PTR [rax]		# eax := *m
	mov	esi, eax			# esi := eax
	lea	rax, .LC0[rip]			# rax := "Повар приготовил еще %d кусков.\n"
	mov	rdi, rax			# rdi := rax
	mov	eax, 0				# eax := 0
	call	printf@PLT			# printf("Повар приготовил еще %d кусков.\n", *(m));
	mov	edi, 0				# edi := 0
	call	pthread_exit@PLT		# завершаем поток
	.size	threadFunc, .-threadFunc
	.section	.rodata

.LC1:
	.string	"%d"				# %d
	.align 8
.LC2:						# "Каннибал %d пообедал, осталось кусков: %d.\n"
	.string	"\320\232\320\260\320\275\320\275\320\270\320\261\320\260\320\273 %d \320\277\320\276\320\276\320\261\320\265\320\264\320\260\320\273, \320\276\321\201\321\202\320\260\320\273\320\276\321\201\321\214 \320\272\321\203\321\201\320\272\320\276\320\262: %d.\n"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp				# сохраняем rbp на стек
	mov	rbp, rsp			# rbp := rsp
	sub	rsp, 48				# rsp -= 48
	lea	rax, -20[rbp]			# rax := -20[rbp] - n
	mov	rsi, rax			# rsi := rax 
	lea	rax, .LC1[rip]			# rax := "%d"
	mov	rdi, rax			# rdi := rax
	mov	eax, 0				# eax := 0
	call	__isoc99_scanf@PLT		# scanf n
	lea	rax, -24[rbp]			# rax := rbp[-24] - m
	mov	rsi, rax			# rsi := rax
	lea	rax, .LC1[rip]			# rax := .LC1
	mov	rdi, rax			# rdi := rax
	mov	eax, 0				# eax := 0
	call	__isoc99_scanf@PLT		# scanf m
	mov	eax, DWORD PTR -24[rbp]		# eax := m 
	mov	DWORD PTR -32[rbp], eax		# cur[0] := m
	mov	eax, DWORD PTR -24[rbp]		# eax := m
	mov	DWORD PTR -28[rbp], eax		# cur[1] := m
	lea	rax, -32[rbp]			# rax := cur[0]
	mov	QWORD PTR -16[rbp], rax		# thread_data := cur
	mov	DWORD PTR -4[rbp], 0		# i := 0
	jmp	.L3				# goto .L3
.L5:
	mov	eax, DWORD PTR -28[rbp]		# eax := cur[1]
	test	eax, eax			# eax == 0
	jne	.L4
	mov	rdx, QWORD PTR -16[rbp]		# rdx := thead_data
	lea	rax, -40[rbp]			# rax := rbp[-40] - thread
	mov	rcx, rdx			# rcx := thread_data
	lea	rdx, threadFunc[rip]		# rdx := threadFunc
	mov	esi, 0				# esi := 0
	mov	rdi, rax			# rdi := thread
	call	pthread_create@PLT		# create thread
	mov	rax, QWORD PTR -40[rbp]		# rax := thread
	mov	esi, 0				# esi := 0
	mov	rdi, rax			# rdi := rax
	call	pthread_join@PLT		# ждём завешения потока
.L4:
	mov	eax, DWORD PTR -28[rbp]		# eax := cur[1]
	sub	eax, 1				# eax--
	mov	DWORD PTR -28[rbp], eax		# cur[1] := eax
	mov	eax, DWORD PTR -28[rbp]		# eax := cur[1]
	mov	edx, DWORD PTR -4[rbp]		# edx := i
	lea	ecx, 1[rdx]			# ecx := i + 1
	mov	edx, eax			# edx := eax
	mov	esi, ecx			# esi := i + 1
	lea	rax, .LC2[rip]			# rax := .LC2
	mov	rdi, rax			# rdi := rax
	mov	eax, 0				# eax := 0
	call	printf@PLT			# printf 
	add	DWORD PTR -4[rbp], 1		# i++
.L3:
	mov	eax, DWORD PTR -20[rbp]		# eax := n
	cmp	DWORD PTR -4[rbp], eax		# i < n
	jl	.L5				# goto .L5
	mov	eax, 0				# eax := 0
	leave					# / return 0
	ret					# \
