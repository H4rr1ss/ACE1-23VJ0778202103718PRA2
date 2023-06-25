mPrint macro variable
    mov dx, offset variable
    mov ah, 09h
    int 21h
endm

getData macro ingreso
    mov dx, offset ingreso
    mov ah, 0a
    int 21
endm