# ExBitcask [![Build Status](https://secure.travis-ci.org/JonGretar/ExBitcask.png?branch=master)](http://travis-ci.org/JonGretar/ExBitcask)

Elixir wrapper of [Basho's Bitcask](https://github.com/basho/bitcask). Bitcask is a Log-Structured Hash Table for Fast
Key/Value Data.

## Notes on Bitcask

Instead of the usual method of requiring the wrapped library as a dependency I have chosen to include the Bitcask source
code in the library. This will vastly simplify getting and compiling the library. On the minus side it will mean that
updating to a new release of Bitcask will take a few days. But I'll try to be quick about it.

ExBitcask currently users version **2.0.0** of bitcask.

## Usage

For full API docs please view the projects [Hexdocs](http://hexdocs.pm/ex_bitcask).

```elixir
db = ExBitcask.open("my.db", [:read_write])
ExBitcask.put(db, "Foo", "bar")
ExBitcask.put(db, "Hello", "world")
ExBitcask.get(db, "Hello")
# {:ok, "world"}
```

### Streams

Lazy Streams can be generated for both the keys and the {key, val} of the database.

```elixir
ExBitcask.stream_keys(db) |> Stream.map(&(String.upcase(&1))) |> Enum.to_list
# ["FOO", "HELLO"]
ExBitcask.stream_keyvals(db) |> Enum.to_list
# [{"Foo", "bar"}, {"Hello", "world"}]
```

### Serialization

If a value is in binary or String format it will be put in as is.
Other terms will be serialized into binary using `:erlang.term_to_binary/1` with a prefix so ExBitcask knows when to de-serialize a value.

This means a value can be any complex Elixir object. Like the database connection itself.

```elixir
ExBitcask.put(db, "myown_db", db)
db_from_db = ExBitcask.get!(db, "myown_db")
ExBitcask.get(db_from_db, "Hello")
# {:ok, "world"}
```

## What is Bitcask

(*[From Wikipedia](https://en.wikipedia.org/wiki/Bitcask)*)

Bitcask is an Erlang application that provides an API for storing and retrieving key/value data into a log-structured
hash table that provides very fast access. The design owes a lot to the principles found in log-structured file systems
and draws inspiration from a number of designs that involve log file merging.

### Strengths

#### Low latency per item read or written
This is due to the write-once, append-only nature of the Bitcask database files. High throughput, especially when
writing an incoming stream of random items Because the data being written doesn't need to be ordered on disk and
because the log structured design allows for minimal disk head movement during writes these operations generally
saturate the I/O and disk bandwidth.

#### Ability to handle datasets larger than RAM w/o degradation
Because access to data in Bitcask is direct lookup from an in-memory hash table finding data on disk is very
efficient, even when data sets are very large.

#### Single Seek to Retrieve Any Value
Bitcask's in-memory hash-table of keys point directly to locations on disk where the data lives. Bitcask never uses
more than one disk seek to read a value and sometimes, due to file-system caching done by the operating system, even
that isn't necessary.

#### Predictable Lookup and Insert Performance
As you might expect from the description above, read operations have a fixed, predictable behavior. What you might not
expect is that this is also true for writes. Write operations are at most a seek to the end of the current file open
writing and an append to that file.

#### Fast, bounded Crash Recovery
Due to the append-only write once nature of Bitcask files, recovery is easy and fast. The only items that might be
lost are partially written records at the tail of the file last opened for writes. Recovery need only review the last
record or two written and verify CRC data to ensure that the data is consistent.

#### Easy Backup
In most systems backup can be very complicated but here again Bitcask simplifies this process due to its append-only
write once disk format. Any utility that archives or copies files in disk-block order will properly backup or copy a
Bitcask database.

### Weakness

#### Keys Must Fit In Memory
Bitcask keeps all keys in memory at all times, this means that your system must have enough memory to contain your
entire keyspace with room for other operational components and operating system resident filesystem buffer space.

## Licence

Licenced under the Apache License 2.0
