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

    ; move 0 into r8, 9 into r9
    mov r8, -1
    mov r9, 9 -1

    IncrementLabel:
      ; do while loop
      inc r8
      inc r9
      call PrintSingleDigitInt     ; call single digit function
      add rsp, 4                   ; pop but throw away the value
      cmp r8, 9-1                  ; compare r8 and ascii 9
      jle IncrementLabel           ; jump if <= goto "LoopLable"

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

PrintSingleDigitInt:
  ; takes in a single digit int and prints the ascii equivalent

  ; when a function is called, the return value is placed on the stack
  ; we need to keep this, so that we can return to the corret place in our program!
  pop r14                     ; pop the return address to r9
  pop r15                     ; pop the "parameter" we placed on the stack
  add r15, 48                 ; add the ascii offset
  push r15                    ; place it back onto the stack

  ; write value on the stack to STDOUT
  mov rax, SYS_WRITE          ; system call for write
  mov rdi, STDOUT             ; file handle 1 is stdout
  mov rsi, rsp                ; the string to write popped from the top of the stack
  mov rdx, 1                  ; number of bytes
  syscall                     ; invoke operating system to do the write

  ; print new line
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newline
  mov rdx, newlineLen
  syscall

  push r14                    ; put the return address back on the stack to get back
  ret                         ; return