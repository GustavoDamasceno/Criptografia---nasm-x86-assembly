all: app

app: encriptar.o decriptar.o main.o
		@gcc -m32 -o bin/app obj/main.o obj/encriptar.o  obj/decriptar.o
		@echo Finish
main.o: encriptar.o decriptar.o
		@gcc -c -m32 src/main.c -o obj/main.o
encriptar.o:
		@nasm -f elf32 src/encriptar.asm -o obj/encriptar.o
decriptar.o:
		@nasm -f elf32 src/decriptar.asm -o obj/decriptar.o
clean:
		@rm obj/* bin/*
