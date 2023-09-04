CC = gcc
CFLAGS = -Wall -fPIC
LDFLAGS = -shared

SRC = module.c
OUT = RedisStackStub.so

all: $(OUT)

$(OUT): $(SRC)
		$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

clean:
	rm -f $(OUT)

