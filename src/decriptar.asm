%define BUF_SIZE 256
section .text
global decriptar
decriptar:
    mov EAX,[ESP+4]
    mov [key],eax
    mov eax,[ESP+8]
    xor esi,esi

    cpin:
    mov ecx,[eax+esi]
    mov [in_file_name+esi],cl
    inc esi
    cmp cl,0
    je donecpin
    jmp cpin

    donecpin:
    call RMEXT

    ;open the target file
    mov EAX,5            ;file open
    mov EBX,in_file_name ;input file name pointer
    mov ECX,0            ;access bits (read only)
    mov EDX,0700         ;file permissions
    int 0x80
    mov [fd_in],EAX      ;store fd for use in read routine

    cmp EAX,0            ;verify if has any error to open the file
    jge create_file
    jmp close_exit

create_file:
    ;create output file
    mov EAX,8                ;file create
    mov EBX,out_file_name    ;output file name pointer
    mov ECX,770             ;r/w/e by owner only
    int 0x80
    mov [fd_out],EAX         ;store fd for use in write routine
    cmp EAX,0                ;create error if fd < 0
    jge repeat_read
    jmp close_exit

repeat_read:
        ; read input file
        mov EAX,3             ;file read
        mov EBX, [fd_in]      ;file descriptor
        mov ECX, in_buf       ;input buffer
        mov EDX, BUF_SIZE     ;size
        int 0x80

        ;criptografia
        push eax
        mov ecx, eax          ;ecx recives size of file
        xor esi, esi          ;clear esi
        mov eax,[key]
crpt:
        xor [in_buf+(esi)],eax  ;crpty
        inc esi                       ;inc esi
        loop crpt
        pop eax

        ;write to output file
        mov EDX,EAX           ;byte count
        mov EAX,4             ;file write
        mov EBX,[fd_out]      ;file descriptor
        mov ECX,in_buf        ;input buffer
        int 0x80

        cmp EDX,BUF_SIZE      ; EDX = # bytes read
        ;cmp EDX,[buf_sz]      ; EDX = # bytes read
        jl  copy_done         ; EDX < BUF_SIZE indicates end-of-file
        jmp repeat_read

copy_done:
        mov EAX,6             ;close output file
        mov EBX,[fd_out]
        int 0x80
close_exit:
        mov EAX,6             ;close input file
        mov EBX,[fd_in]
        int 0x80
        mov eax,-1            ;if has an error returns -1
        ret
.done:
    xor eax,eax
    ret

RMEXT:
    push esi
    push esi
    push ecx

    xor esi,esi
    xor eax,eax

    cp:
    mov cl,[in_file_name+esi]
    cmp cl,0
    jle rmetxc
    mov [out_file_name+esi],cl
    inc esi
    jmp cp

    xor eax,eax
    rmetxc:
    mov BYTE[out_file_name+(esi)],0
    inc eax
    dec esi
    cmp eax,5
    jle rmetxc

    addext:
    mov ecx,[extc]
    inc esi
    mov [out_file_name+esi],cl
    mov ecx,[extc+1]


    done:
    pop ecx
    pop eax
    pop esi
    ret

section .data
    extc db "_", 0

section .bss
    in_file_name  resb 100
    out_file_name resb 100
    fd_in         resd 1
    fd_out        resd 1
    in_buf        resd BUF_SIZE
    key           resb 1
