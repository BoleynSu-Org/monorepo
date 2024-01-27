# backward-chaining
A Prolog like language using backward chaining algorithm. This is part of BSL (a.k.a Boleyn Su's Language) project.

Compile main.cpp and then run the excuatable with an argument which is the path to the rules and facts. Then you can do some queries.

[example/r.pl](example/r.pl) is an example rule file. [example/q.pl](example/q.pl) are example quries.

You can use following command to play with the example.

```bash
g++ main.cpp;./a.out example/r.pl < example/q.pl
```
