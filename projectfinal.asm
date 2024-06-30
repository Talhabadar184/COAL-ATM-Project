.model small
.stack 200h
.data        

;password structure
x db 10,13,10,13,"Enter Your Password:$"
y db 10,13,10,13,"Invalid Password",10,13,"Enter to contiune$"
pass db "1357$"
pass1 dw 4  

;options structure
wel db 10,13,"          Welcome to Your Account",0 
bal db 10,13,"1.Balance Inquiry$"
witd db 10,13,"2.Money Withdraw$" 
tran db 10,13,"3.Transfer Money$"
ex db 10,13,"4.Exit$"
thanks db 10,13,10,13,"                   Thank You For Banking With HATS. $"
;back db 10,13,"1.$"
ext db 10,13,"Press any key to Exit$"
newline db 10,13,"$"

; money withdraw
fiveh db 10,13,"1.     500 pkr$"
onet db 10,13, "2.   1,000 pkr$"
threet db 10,13,"3.   3,000 pkr$"
fivet db 10,13,"4.   5,000 pkr$"
tent db 10,13, "5.  10,000 pkr$"
fiftt db 10,13,"6.  15,000 pkr$" 
twntt db 10,13,"7.  20,000 pkr$"

;amount options
wamount db 10,13,"Select the AmountYyou wanna Withdraw$"
tamount db 10,13,10,13,"Select the Amount You want to Transfer$"
wsuccess db 9,13,"Your Transaction is Successfull...$"
tsuccess db 9,13,"your amount transfer successfully$"
accnumber db 11,13,10,13,10,13,"Enter the Account Number to Transfer the Amount$"
invalidacc db 11,13,"Invalid Account  Number$"
invalidinp db 11,13,"Invalid Input",10,13,10,13,"Press any key exit$"

;balace inquiry
totalbal db 10,13,10,13,"Your Total Balance is:50,000 pkr $" 
avaibal db 10,13,"Your Available Balance is 49,500 pkr $"

;balamce options after withdraw or tranfer
tw1 db 10,13,"Your Total Balance is: 49,500 pkr$"
tw2 db 10,13,"Your Total Balance is: 49,000 pkr$"
tw3 db 10,13,"Your Total Balance is: 47,000 pkr$"
tw4 db 10,13,"Your Total Balance is: 45,000 pkr$" 
tw5 db 10,13,"Your Total Balance is: 40,000 pkr$"
tw6 db 10,13,"Your Total Balance is: 35,000 pkr$"
tw7 db 10,13,"Your Total Balance is: 30,000 pkr$"

.code
 main proc
    mov ax,@data
    mov ds,ax
        
    btp:    
    mov ah,0      ;using interrupt to clean the screen
    mov al,3h     ;setting al 3h to set text mode 80x25
    int 10h
    
    mov ah,0x9
    mov dx,offset x
    int 21h
    
    ;password checking
    mov bx,offset pass
    mov cx,pass1
   
    ;checking character one by one if match then set * to console  
    check:
    
    mov cx,4 
    mov bx,0
    nl:
    mov ah,7     ;input (without echo) 
    int 21h   
    sub al,30h 
   or bl,al
   cmp cx,1
   je nr
   rol bx,4
   nr:
   mov ah,2      ;using interrupt to print the value of dl
    mov dl,42 ;moving * to dl when first entery of input match the password
    int 21h 
    loop nl
   
    mov ax,1357h
    cmp bx,ax
    
     jne wrongpass
     
    mov ah,0      ;using interrupt to clean the screen
    mov al,3h     ;setting al 3h to set text mode 80x25
    int 10h 
   
    jmp mainproc 
   
    wrongpass:
    mov ah,0      ;using interrupt to clean the screen
    mov al,3h     ;setting al 3h to set text mode 80x25
    int 10h 
    mov ah,9h
    mov dx,offset y       ;printing invalid password using interrupt
    int 21h
    mov ah,0x7
    int 21h
    jmp btp
    
    mainproc: 
    mov ah,0x00
    mov al,0x03
    int 0x10
    
    mov ax,0xb800
    mov es,ax 
    mov ax,0
    mov si,200
    mov bx,offset wel
    mov di,0 
    display:
    mov al,[bx+di] 
    cmp al,0
    je balopt
    mov es:[si],al
    inc si
    mov byte ptr es:[si],00000010b 
    inc si
    inc di
    jmp display      ;printing welcome through video memory
    balopt:
     mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset bal   ;printing the balance inquiry
    int 21h
    mov ah,9
    mov dx,offset witd  ;printing the withdraw
    int 21h
    mov ah,9
    mov dx,offset tran  ;printing the transaction
    int 21h
    mov ah,9
    mov dx,offset ex  ;printing exit
    int 21h 
    mov ah,9
    mov dx,offset newline ;moving to new line 
    int 21h
    mov ah,1
    int 21h
    mov bl,al
   
    cmp bl,49
    je balance   ;compairing 1 for balance inqury
    cmp bl,50
    je withdraw ;compairing 2 for withdraw
    cmp bl,51
    je transfer ;compairing 3 for transfer
    cmp bl,52
    je exit
    jmp error
                  
    ;For Balance inquiry
    balance:
    mov ah,0      ;using interrupt to clean the screen
    mov al,3h     ;setting al 3h to set text mode 80x25
    int 10h
    mov ah,9
    mov dx,offset totalbal   ;printing the total balance
    int 21h
    mov ah,9 
    mov dx,offset avaibal ;printing the available balance 
    int 21h
    jmp option
    
    ;For Withdraw
    withdraw:
    mov ah,0
    mov al,3  ;clearing the screen
    int 10h
    mov ah,9
    mov dx, offset newline    ;moving to new line
    int 21h
    mov ah,9
    mov dx,offset wamount ;printing the withdraw selection string
    int 21h
    
    ;Withdraw Options
    mov ah,9
    mov dx,offset fiveh  ;500
    int 21h
    mov ah,9
    mov dx,offset onet ;1000
    int 21h
    mov ah,9
    mov dx,offset threet ;3000
    int 21h
    mov ah,9
    mov dx,offset fivet  ;5000
    int 21h
    mov ah,9
    mov dx,offset tent   ;10,000
    int 21h              
    mov ah,9
    mov dx,offset fiftt  ;15,000
    int 21h
    mov ah,9
    mov dx,offset twntt  ;20,000
    int 21h
     mov ah,9
    mov dx, offset newline  ;25,000
    int 21h
    mov ah,1
    int 21h      ;taking input through interrupt
    mov bl,al    ;movimg it to bl
    
     ;Input Condition Cheek
    cmp bl,49     ;compairing 1 for 500
    je process1 
    
    cmp bl,50   ;compairing 2 for 1000
    je process2
    
    cmp bl,51    ;compairing 3 for 3000
    je process3
    
    cmp bl,52
    je process4   ;compairing 4 for 5000
      
    cmp bl,53
    je process5  ;compairing 5 for 10,000
    
    cmp bl,54    ;compairing 6 for 15,000
    je process6
    
    cmp bl,55
    je process7  ;compairing 6 for 20,000
    jmp error 
    
    
      ;process 1 for 500
    process1:
    mov ah,0x00
    mov al,0x03
    int 0x10      ;clearing the screen
    mov ah,9
    mov dx,offset wsuccess  ;printing that ur transaction is successful
    int 21h 
     mov ah,9
    mov dx,offset newline  ;moving to new line
    int 21h
    mov ah,9
    mov dx,offset tw1 ;printing the remaining balance
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 2 for 1000
    process2:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset wsuccess  ;printing that ur transaction is successful
    int 21h 
     mov ah,9
    mov dx,offset newline ;moving to new line
    int 21h
    mov ah,9
    mov dx,offset tw2      ;printing the remaining balance
    int 21h  
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 3 for three thousand
     process3:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov  dx,offset wsuccess   ;printing that ur transaction is successful
    int 21h 
    mov ah,9
    mov dx,offset newline   ;moving to new line
    int 21h 
    mov ah,9
    mov dx,offset tw3  ;printing the remaining balance
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 4 for five thousand
    process4:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset wsuccess  ;printing that ur transaction is successful
    int 21h 
    mov ah,9
    mov dx,offset newline ;moving to new line
    int 21h 
    mov ah,9
    mov dx,offset tw4
    int 21h             ;printing the remaining balance
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
      ;process 5 for ten thousand
    process5:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset wsuccess  ;printing that ur transaction is successful
    int 21h 
    mov ah,9
    mov dx,offset newline ;moving to new line
    int 21h 
    mov ah,9
    mov dx,offset tw5
    int 21h                ;printing the remaining balance
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
      ;process 6 for fifteen thousand
    process6:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset wsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw6
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option 
    
      ;process 7 for twenty thousand
    process7:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset wsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw7
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
   ;money transfer  
    Transfer: 
    mov ah,0x00
    mov al,0x03  ;clearing the screen
    int 0x10
    mov ah,9
    mov dx,offset accnumber ;askig for account number string
    int 21h    
     mov ah,9
    mov dx,offset newline   ;new line
    int 21h 
    
    mov di,0
    mov ah,1
   
    l2:
    int 21h
    inc di          ;increment di in every input
    cmp di,000Dh    ;when di is 13 then next
     
    jne l2
    
    
      
     mov ah,9
    mov dx,offset newline ;new line
    int 21h 
    
    
    
     ;password checking
    mov bx,offset pass
    mov cx,pass1 
    
    ;printing the string of named x
    mov ah,9            
    mov dx,offset x
    int 21h            
      
    ;checking character one by one if match then set * to console  
    check1: 
   
    mov cx,4 
    mov bx,0
    nl1:
    mov ah,7     ;input (without echo) 
    int 21h   
    sub al,30h 
   or bl,al
   cmp cx,1
   je nr1
   rol bx,4
   nr1:
   mov ah,2      ;using interrupt to print the value of dl
    mov dl,42 ;moving * to dl when first entery of input match the password
    int 21h 
    loop nl1
    mov ax,1357h
    cmp ax,bx
    
     jne wrongpass
     mov cx,4
      l3: 
    mov ah,2      ;using interrupt to print the value of dl
    mov dl,42 ;moving * to dl when first entery of input match the password
    int 21h   
    loop l3 
    mov ah,0      ;using interrupt to clean the screen
    mov al,3h     ;setting al 3h to set text mode 80x25 
    int 10h
    
     ;Money Transfer Proccess
   
    mov ah,9
    mov dx,offset tamount
    int 21h  
    ;Transfer Amount Display
    mov ah,9
    mov dx,offset fiveh  ;500
    int 21h
    mov ah,9
    mov dx,offset onet  ;1000
    int 21h
    mov ah,9
    mov dx,offset threet ;3000
    int 21h
    mov ah,9
    mov dx,offset fivet  ;5000
    int 21h
    mov ah,9
    mov dx,offset tent  ;10,000
    int 21h              
    mov ah,9
    mov dx,offset fiftt ;15,000
    int 21h
    mov ah,9
    mov dx,offset twntt ;20,000
    int 21h
     mov ah,9
    mov dx, offset newline ;newline
    int 21h
    mov ah,1
    int 21h
    mov bl,al
    
       ;Input Condition Cheek
    cmp bl,49 
    je process8  
    cmp bl,50 
    je process9
    cmp bl,51 
    je process10
    cmp bl,52
    je process11  
    cmp bl,53
    je process12
    cmp bl,54
    je process13
    cmp bl,55
    je process14
    jmp error 
    
      ;process 1 for 500
    process8:
    mov ah,0x00
    mov al,0x03
    int 0x10      ;clearing the screen
    mov ah,9
    mov dx,offset tsuccess  ;printing that ur transaction is successful
    int 21h 
     mov ah,9
    mov dx,offset newline
    int 21h
    mov ah,9
    mov dx,offset tw1
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 2 for 1000
    process9:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset tsuccess
    int 21h 
     mov ah,9
    mov dx,offset newline
    int 21h
    mov ah,9
    mov dx,offset tw2
    int 21h  
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 3 for three thousand
     process10:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov  dx,offset tsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw3
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
    ;process 4 for five thousand
    process11:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset tsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw4
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
      ;process 5 for ten thousand
    process12:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset tsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw5
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option
    
      ;process 6 for fifteen thousand
    process13:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset tsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw6
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option 
    
      ;process 7 for twenty thousand
    process14:
    mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset tsuccess
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h 
    mov ah,9
    mov dx,offset tw7
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h
    jmp option 

    option:
     mov ah,9
    mov dx,offset newline
    int 21h
    mov ah,9
    mov dx,offset ext
    int 21h
    mov ah,9
    mov dx,offset newline
    int 21h
    mov ah,1
    int 21h
    jmp exit
    
    bac: 
     mov ah,0x00
    mov al,0x03
    int 0x10
    call mainproc
  
    error:
     mov ah,0x00
    mov al,0x03
    int 0x10 
    mov ah,9
    mov dx,offset invalidinp
    int 21h 
    mov ah,9
    mov dx,offset newline
    int 21h  
    mov ah,7
    int 21h
     
     
     exit:
     mov ah,0x00
    mov al,0x03
    int 0x10
    mov ah,9
    mov dx,offset thanks
    int 21h 
    mov ah,4ch
    int 21h
    main endp
end main     
     
     