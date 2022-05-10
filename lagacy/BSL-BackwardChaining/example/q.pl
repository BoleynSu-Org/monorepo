willDie(a).
willDie(b).

%X=concat([a,b],[c])
concat(cons(a,cons(b,nil)),cons(c,nil),X).

%2+X=3
add(s(s(z)),X,s(s(s(z)))).

%2*X=6
mul(s(s(z)),X,s(s(s(s(s(s(z))))))).

%X*Y=6
mul(X,Y,s(s(s(s(s(s(z))))))).

%A->B->C->D->E->A
and(and(and(and(e(A,B),e(B,C)),e(C,D)),e(D,E)),e(E,A)).

%ABC is a triangle
triangle(A,B,C).

%(X+1)*(X+2)=6
and(and(add(X,s(z),Y),add(X,s(s(z)),Z)),mul(Y,Z,s(s(s(s(s(s(z)))))))).

%(~A)&(~C)&(A|B)
and(labeling(A),
and(labeling(B),
and(labeling(C),
sat(land(lnot(A),land(lnot(C),lor(A,B))))
))).

% Who's lying and who's telling the truth?
% Mr. Adams claims that Mr. Brown lies.
% Mr. Brown says that it is Mr. Caroll who lies.
% Mr. Caroll believes that both Mr. Adams and Mr. Brown lie.
% So there is a question: who is lying, and who is telling the truth here?

and(labeling(A),
and(labeling(B),
and(labeling(C),
sat(
land(liff(lnot(B),A),
land(liff(lnot(C),B),
liff(land(lnot(A),lnot(B)),C)
)))
))).

%X=a(X)
eq(X,a(X)).

