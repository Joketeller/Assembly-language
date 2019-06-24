.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib

fopen	proto c:dword,:dword
fgets	proto c:dword,:dword,:dword
fclose  proto c:dword
strcmp	proto c:dword,:dword
strlen	proto c:dword
scanf	proto c szformat:dword,:vararg
printf	proto c:dword,:vararg

.data
fp1	dword	?
buf1	byte	1024 dup(0)		;���뵽������
bytes1	dword	?			;���������	
pos1	dword	0			;��дָ���λ��
file1	byte	"11.txt",0

fp2	dword	?
buf2	byte	1024 dup(0)		;���뵽������
bytes2	dword	?			;���������
pos2	dword	0			;��дָ���λ��
file2	byte	"12.txt",0

no	dword	0			;��ʾ�к�
flag	dword	0			;��������ļ��Ƿ��в���ͬ��
mode	byte	"rb",0			;���붨����ֽ��͵�
res	byte	'No.%d is different.',0ah,0
sz	byte	"The two files are the same.",0ah,0

.code
start:
	
	invoke	fopen,offset file1,offset mode		;����*fp�� ��������ֵ��eax
	mov	fp1,eax
	invoke	fopen,offset file2,offset mode
	mov	fp2,eax

L1:
	xor	eax,eax
	mov	buf1,al
	mov	buf2,al
	invoke	fgets,offset buf1,1024,fp1
	push	eax
	invoke	fgets,offset buf2,1024,fp2
	push	eax
	inc	no					;���к�+1��������flag��flagֻ��59��+1
	
	;**********�˴����������س���������Ĵ��󣬺��Իس���������Ĳ���*******
	;fgets���ı��ļ��Ļ����Ƕ����ļ��ġ��س����롰���С��ַ�ʱ�������ַ�ת��Ϊ���У���0dh�������ַ���ĩβ����0�ַ�
	;strlen���0�ַ�Ҳ����������һλ�����Ҫ-2��һλ�ǻ����ַ�������λ��
	
	invoke strlen,offset buf1
	sub eax,2					
	.if buf1[eax]  == 0dh
		xor ebx,ebx
		mov buf1[eax],bl
	.endif
	invoke strlen,offset buf2
	sub eax,2
	.if buf2[eax]  == 0dh
		xor ebx,ebx
		mov buf2[eax],bl
	.endif
	
	;********�Ƚ϶���������ַ������޲���************
	invoke	strcmp,offset buf1,offset buf2
	cmp	eax,0
	jnz	L2
L3:	pop	eax
	pop	ebx					;�˴���Ƚ������ļ��Ƿ��������ͷ����Ϊ�����ļ��������Բ�ͬ
	cmp	eax,ebx
	jz	L4
	jmp	L1	
L2:
	inc flag
	invoke	printf,offset res,no	
	jmp	L3
	
L4:	
	mov	eax,flag
	cmp 	eax,0
	jnz	L5
	invoke	printf,offset sz
L5:
	invoke	 fclose,fp1
	invoke	 fclose,fp2
	ret
	
end start