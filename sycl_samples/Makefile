CC = icpx
CFLAGS = -fsycl
PROGRAMS = device_info add_nums enum_devices

all: $(PROGRAMS)

$(PROGRAMS): % : %.cpp
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(PROGRAMS)

run:
	./device_info
	./add_nums
	./enum_devices
