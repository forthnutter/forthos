KERNEL_OBJS = boot.o gdt.o idt.o kernel.o
TEST_OBJS = test.o
LDFLAGS = -Tlink.ld  -melf_i386
ASFLAGS = -g -felf32
asm = nasm

.s.o:
	$(asm) $(ASFLAGS) $<


kernel: $(KERNEL_OBJS) 
	ld $(LDFLAGS) -o kernel $(KERNEL_OBJS)

test: $(TEST_OBJS)
	ld  $(LDFLAGS) -o test $(TEST_OBJS)

image: kernel
	cp -f floppy.orig.img floppy.img
	sudo losetup /dev/loop0 floppy.img
	sudo mount /dev/loop0 /mnt
	sudo cp kernel /mnt/kernel
	-sudo umount /dev/loop0
	-sudo losetup -d /dev/loop0 

kernel.o: forth_words.s forth_core.s kernel_video.s


run: image
	sudo /sbin/losetup /dev/loop0 floppy.img
	-sudo bochs -f bochsrc.txt || sudo /sbin/losetup -d /dev/loop0 

clean:
	rm -f *.o core kernel test



