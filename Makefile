CC = gcc
CFLAGS = -Wall -fPIC
LDFLAGS = -shared

SRC = module.c
OUT = ./bin/rediscompat.so

all: $(OUT)

$(OUT): $(SRC)
		@mkdir -p ./bin
		$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

clean:
	rm -f $(OUT)

