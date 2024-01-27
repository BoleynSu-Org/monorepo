willDie(X):-isHuman(X).
isHuman(a).

concat(nil,Y,Y).
concat(cons(X,XS),Y,cons(X,Z)):-concat(XS,Y,Z).

add(z,Y,Y).
add(s(X),Y,s(Z)):-add(X,Y,Z).

mul(z,X,z).
mul(X,z,z).
mul(s(X),s(Y),s(Z)):-add(B,Y,Z),add(A,X,B),mul(X,Y,A).

eq(X,X).

e(u1,u2).
e(u2,u3).
e(u3,u1).
e(u3,u4).
e(u4,u5).
e(u1,u4).
e(u5,u1).

and(X,Y):-X,Y.

triangle(A,B,C):-e(A,B),e(B,C),e(C,A).
triangle(A,B,C):-e(A,B),e(B,C),e(A,C).
triangle(A,B,C):-e(A,B),e(C,B),e(C,A).
triangle(A,B,C):-e(A,B),e(C,B),e(A,C).
triangle(A,B,C):-e(B,A),e(B,C),e(C,A).
triangle(A,B,C):-e(B,A),e(B,C),e(A,C).
triangle(A,B,C):-e(B,A),e(C,B),e(C,A).
triangle(A,B,C):-e(B,A),e(C,B),e(A,C).

label(X,true):-eq(X,true).
label(X,false):-eq(X,false).
label(land(X,Y),true):-label(X,true),label(Y,true).
label(land(X,Y),false):-label(X,false),label(Y,true).
label(land(X,Y),false):-label(X,true),label(Y,false).
label(land(X,Y),false):-label(X,false),label(Y,false).
label(lor(X,Y),true):-label(X,true),label(Y,true).
label(lor(X,Y),true):-label(X,true),label(Y,false).
label(lor(X,Y),true):-label(X,false),label(Y,true).
label(lor(X,Y),false):-label(X,false),label(Y,false).
label(lnot(X),true):-label(X,false).
label(lnot(X),false):-label(X,true).
label(lif(X,Y),Z):-label(lor(lnot(X),Y),Z).
label(liff(X,Y),Z):-label(land(lif(X,Y),lif(Y,X)),Z).
labeling(X):-eq(X,true).
labeling(X):-eq(X,false).
sat(X):-label(X,true).


