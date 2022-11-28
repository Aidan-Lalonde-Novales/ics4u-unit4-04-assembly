; ----------------------------------------------;
; This program uses a loop to output numbers.   ;
; For x86 only.                                 ;
;                                               ;
; By: Aidan Lalonde-Novales                     ;
; Version: 1.0                                  ;
; Since: 2022-11-28                             ;
; ----------------------------------------------;

; System Call Definitions
;-----------------------------------------------;
SYS_WRITE equ 1 ; write to _
SYS_EXIT equ 60 ; end program
STDOUT equ 1    ; define standard output
;-----------------------------------------------;

section .bss
  numLen equ 2                                    ; length of output
  num resb numLen                                ; variable to hold numbers

section .data
  newline: db 10                                   ; represents new line
  newlineLen: equ $-newline                        ; length of new line
  opening: db "Printing Fibonacci Sequence...", 10 ; first line to be printed
  openingLen: equ $-opening                        ; length of opneing
  done: db "Done.", 10                             ; ending line
  doneLen: equ $-done                              ; length of done

section .text
  global_start:                                    ; entry point for linker

  _start:
    ; print opening
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, opening
    mov rdx, openingLen
    syscall

    ; print new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, newlineLen
    syscall

    ; assign ascii characters to registers (0 and 9 respectively)
    mov r8, 48

    loop:
    ; mov value of r8 to number output variable
    mov [temp], r8

    ; r8 + 1
    inc r8

    ; print temp
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, temp
    mov rdx, tempLen
    syscall

    ; print new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, newlineLen
    syscall

    ; compare
    cmp r8, 57
    jle loop   ; Jump up to loop if r8 <= 57

    ; print new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, newlineLen
    syscall

    ; print done
    mov rax, SYS_WRITE         ; sys_write
    mov rdi, STDOUT            ; stdout
    mov rsi,done               ; line to write
    mov rdx,doneLen            ; line length
    syscall                    ; call kernal

    ; end program with error code 0 (success)
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
