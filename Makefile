.PHONY: test clean
CC?=clang
ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
ERLANG_FLAGS?=-I$(ERLANG_PATH)
EBIN_DIR?=ebin

NOOUT=2>&1 >/dev/null

BUILD_DIR=_build
DEPS_DIR=deps
PRIV_DIR=priv
SRC_DIR=src
TEST_DIR=test
TMP_DIR=tmp

C_SRC_DIR=c_src
C_SRC_C_FILES=$(sort $(wildcard $(C_SRC_DIR)/*.c))
C_SRC_O_FILES=$(C_SRC_C_FILES:.c=.o)

NIF_LIB=$(PRIV_DIR)/bitcask.so

OPTIONS=-shared
ifeq ($(shell uname),Darwin)
OPTIONS+= -dynamiclib -undefined dynamic_lookup
endif
INCLUDES=-I$(C_SRC_DIR)

OPTFLAGS?=-fPIC -std=c99 -Wall
CFLAGS=-O2 $(OPTFLAGS) $(INCLUDES)
CMARK_OPTFLAGS=-DNDEBUG

### TARGETS

all:
	mix compile

docs:
	MIX_ENV=docs mix deps.get
	MIX_ENV=docs mix docs

test:
	mix test

build-objects: $(C_SRC_O_FILES)

$(C_SRC_DIR)/%.o : $(C_SRC_DIR)/%.c
	$(CC) $(CMARK_OPTFLAGS) $(ERLANG_FLAGS) $(CFLAGS) -o $@ -c $<

$(C_SRC_DIR):
	mkdir -p $@

$(PRIV_DIR):
	@mkdir -p $@ $(NOOUT)

$(NIF_LIB): $(PRIV_DIR) $(C_SRC_O_FILES)
	$(CC) $(CFLAGS) $(ERLANG_FLAGS) $(OPTIONS) $(C_SRC_O_FILES) -o $@
