	.file	"heap.c"
	.intel_syntax noprefix
	.text
	.globl	brk_current
	.bss
	.align 8
	.type	brk_current, @object
	.size	brk_current, 8
brk_current:
	.zero	8
	.globl	original_brk
	.align 8
	.type	original_brk, @object
	.size	original_brk, 8
original_brk:
	.zero	8
	.globl	livre
	.type	livre, @object
	.size	livre, 1
livre:
	.zero	1
	.globl	em_uso
	.data
	.type	em_uso, @object
	.size	em_uso, 1
em_uso:
	.byte	1
	.text
	.type	procura_bloco_livre, @function
procura_bloco_livre:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -56[rbp], rdi
	mov	eax, esi
	mov	BYTE PTR -60[rbp], al
	mov	QWORD PTR -40[rbp], 0
	cmp	QWORD PTR -56[rbp], 0
	je	.L2
	cmp	BYTE PTR -60[rbp], 1
	ja	.L2
	mov	rax, QWORD PTR original_brk[rip]
	test	rax, rax
	je	.L2
	mov	rax, QWORD PTR brk_current[rip]
	test	rax, rax
	jne	.L3
.L2:
	mov	eax, 0
	jmp	.L4
.L3:
	mov	rax, QWORD PTR original_brk[rip]
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR brk_current[rip]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jb	.L5
	mov	eax, 0
	jmp	.L4
.L5:
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -48[rbp], rax
	jmp	.L6
.L11:
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 1[rax]
	mov	rdx, QWORD PTR -24[rbp]
	sub	rdx, QWORD PTR -48[rbp]
	sub	rdx, 9
	cmp	rdx, rax
	jnb	.L7
	mov	eax, 0
	jmp	.L4
.L7:
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR 1[rax]
	mov	rax, QWORD PTR -48[rbp]
	add	rax, rdx
	add	rax, 9
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	edx, al
	movzx	eax, BYTE PTR livre[rip]
	movsx	eax, al
	cmp	edx, eax
	jne	.L8
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 1[rax]
	cmp	rax, QWORD PTR -56[rbp]
	jb	.L8
	cmp	QWORD PTR -40[rbp], 0
	je	.L9
	cmp	BYTE PTR -60[rbp], 0
	jne	.L10
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 1[rax]
	mov	rdx, QWORD PTR -40[rbp]
	mov	rdx, QWORD PTR 1[rdx]
	cmp	rdx, rax
	jb	.L9
.L10:
	cmp	BYTE PTR -60[rbp], 1
	jne	.L8
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR 1[rax]
	mov	rax, QWORD PTR -40[rbp]
	mov	rax, QWORD PTR 1[rax]
	cmp	rdx, rax
	jnb	.L8
.L9:
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -40[rbp], rax
.L8:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -48[rbp], rax
.L6:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 9
	cmp	QWORD PTR -24[rbp], rax
	jnb	.L11
	mov	rax, QWORD PTR -40[rbp]
.L4:
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	procura_bloco_livre, .-procura_bloco_livre
	.type	abre_novo_bloco, @function
abre_novo_bloco:
.LFB1:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	QWORD PTR -40[rbp], rdi
	cmp	QWORD PTR -40[rbp], 0
	jne	.L13
	mov	eax, 0
	jmp	.L14
.L13:
	cmp	QWORD PTR -40[rbp], -10
	jbe	.L15
	mov	eax, 0
	jmp	.L14
.L15:
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 9
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	rdi, rax
	call	sbrk@PLT
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], -1
	jne	.L16
	mov	eax, 0
	jmp	.L14
.L16:
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	movzx	eax, BYTE PTR em_uso[rip]
	mov	edx, eax
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR 1[rax], rdx
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	QWORD PTR brk_current[rip], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 9
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	abre_novo_bloco, .-abre_novo_bloco
	.globl	setup_brk
	.type	setup_brk, @function
setup_brk:
.LFB2:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edi, 0
	call	sbrk@PLT
	mov	QWORD PTR original_brk[rip], rax
	mov	rax, QWORD PTR original_brk[rip]
	mov	QWORD PTR brk_current[rip], rax
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	setup_brk, .-setup_brk
	.globl	dismiss_brk
	.type	dismiss_brk, @function
dismiss_brk:
.LFB3:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edi, 0
	call	sbrk@PLT
	mov	QWORD PTR brk_current[rip], rax
	mov	rax, QWORD PTR original_brk[rip]
	mov	rdi, rax
	call	brk@PLT
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	dismiss_brk, .-dismiss_brk
	.globl	memory_alloc
	.type	memory_alloc, @function
memory_alloc:
.LFB4:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	QWORD PTR -40[rbp], rdi
	mov	eax, esi
	mov	BYTE PTR -44[rbp], al
	cmp	QWORD PTR -40[rbp], 0
	je	.L20
	cmp	BYTE PTR -44[rbp], 1
	jbe	.L21
.L20:
	mov	eax, 0
	jmp	.L22
.L21:
	movzx	edx, BYTE PTR -44[rbp]
	mov	rax, QWORD PTR -40[rbp]
	mov	esi, edx
	mov	rdi, rax
	call	procura_bloco_livre
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	je	.L23
	mov	rax, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR 1[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 10
	cmp	QWORD PTR -16[rbp], rax
	jb	.L24
	mov	rax, QWORD PTR -40[rbp]
	lea	rdx, 9[rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	movzx	eax, BYTE PTR livre[rip]
	mov	edx, eax
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR -16[rbp]
	sub	rax, QWORD PTR -40[rbp]
	lea	rdx, -9[rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR 1[rax], rdx
	mov	rax, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR 1[rax], rdx
.L24:
	movzx	eax, BYTE PTR em_uso[rip]
	mov	edx, eax
	mov	rax, QWORD PTR -24[rbp]
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 9
	jmp	.L22
.L23:
	mov	rax, QWORD PTR -40[rbp]
	mov	rdi, rax
	call	abre_novo_bloco
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	memory_alloc, .-memory_alloc
	.globl	memory_free
	.type	memory_free, @function
memory_free:
.LFB5:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -72[rbp], rdi
	cmp	QWORD PTR -72[rbp], 0
	je	.L26
	mov	rax, QWORD PTR original_brk[rip]
	test	rax, rax
	je	.L26
	mov	rax, QWORD PTR brk_current[rip]
	test	rax, rax
	jne	.L27
.L26:
	mov	eax, 0
	jmp	.L28
.L27:
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR original_brk[rip]
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR brk_current[rip]
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -56[rbp], rax
	jmp	.L29
.L33:
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR 1[rax]
	mov	rdx, QWORD PTR -32[rbp]
	sub	rdx, QWORD PTR -56[rbp]
	sub	rdx, 9
	cmp	rdx, rax
	jnb	.L30
	mov	eax, 0
	jmp	.L28
.L30:
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 9
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR 1[rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -48[rbp]
	jne	.L31
	mov	rax, QWORD PTR -24[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	edx, al
	movzx	eax, BYTE PTR em_uso[rip]
	movsx	eax, al
	cmp	edx, eax
	je	.L32
	mov	eax, 0
	jmp	.L28
.L32:
	movzx	eax, BYTE PTR livre[rip]
	mov	edx, eax
	mov	rax, QWORD PTR -24[rbp]
	mov	BYTE PTR [rax], dl
	mov	eax, 1
	jmp	.L28
.L31:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -56[rbp], rax
.L29:
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 9
	cmp	QWORD PTR -32[rbp], rax
	jnb	.L33
	mov	eax, 0
.L28:
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	memory_free, .-memory_free
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
