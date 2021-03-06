/*
 * gensim_processor_api.S
 *
 *  Created on: 21 Jul 2015
 *      Author: harry
 */

.text

.globl genc_bswap32
genc_bswap32:
	bswap %edi
	mov %edi, %eax
	ret
.globl genc_bswap64
genc_bswap64:
	bswap %rdi
	mov %rdi, %rax
	ret

// %rdi: lhs
// %rsi: rhs
// %rdx: carry_in
// output: SZ0A0P1C0000000V

.globl genc_adc_flags
genc_adc_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %esi, %r11d

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_adc_flags, .-genc_adc_flags

.globl genc_adc8_flags
genc_adc8_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %sil, %r11b

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_adc_flags, .-genc_adc_flags

.globl genc_adc16_flags
genc_adc16_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %si, %r11w

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_adc_flags, .-genc_adc_flags

.globl genc_adc64_flags
genc_adc64_flags:
	mov %rdi, %r11
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %rsi, %r11

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_adc64_flags, .-genc_adc64_flags

.globl genc_sbc_flags
genc_sbc_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %esi, %r11d

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_sbc_flags, .-genc_sbc_flags

.globl genc_sbc8_flags
genc_sbc8_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %sil, %r11b

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_sbc_flags, .-genc_sbc_flags

.globl genc_sbc16_flags
genc_sbc16_flags:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %si, %r11w

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_sbc_flags, .-genc_sbc_flags

.globl genc_sbc64_flags
genc_sbc64_flags:
	mov %rdi, %r11
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %rsi, %r11

	// read out flags into correct format
	lahf
	seto %al

	// return
	retq
.size genc_sbc64_flags, .-genc_sbc64_flags

.globl genc_adc
genc_adc:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %esi, %r11d
	mov %r11d, %eax
	retq
.size genc_adc, .-genc_adc

.globl genc_adc64
genc_adc64:
	mov %rdi, %r11
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	adc %rsi, %r11
	mov %r11, %rax
	retq
.size genc_adc64, .-genc_adc64

.globl genc_sbc
genc_sbc:
	mov %edi, %r11d
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %esi, %r11d

	mov %r11d, %eax
	ret
.size genc_sbc, .-genc_sbc

.globl genc_sbc64
genc_sbc64:
	mov %rdi, %r11
	// set carry flag and clear ecx
	movb $0xff, %al
	addb %dl, %al

	// perform add with carry
	sbb %rsi, %r11

	mov %r11, %rax
	ret
.size genc_sbc64, .-genc_sbc64
