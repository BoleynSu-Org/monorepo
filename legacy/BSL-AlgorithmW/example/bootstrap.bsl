-- ffi types
data FfiString {}
data FfiInt {}

-- builtin types
data Char {}
data Int {}

-- std library
data Unit {
    Unit:Unit
}

data Bool {
    False:Bool;
    True:Bool
}

data List a {
  Nil:forall a.List a;
  Cons:forall a.a->List a->List a
}

data Pair a b {
    Pair:forall a.forall b.a->b->Pair a b
}

data Either a b {
    Left:forall a.forall b.a->Either a b;
    Right:forall a.forall b.b->Either a b
}

data Maybe a {
    Nothing:forall a.Maybe a;
    Just:forall a.a->Maybe a
}

data RealWorld {
    RealWorld:RealWorld
}

data Ordering {
    LT:Ordering;
    EQ:Ordering;
    GT:Ordering
}

data Eq a {
    MkEq:forall a.(a->a->Bool)->Eq a
}

data Ord a {
    MkOrd:forall a.(Eq a)-> -- Eq a
                   (a->a->Ordering)-> -- compare
                   Ord a
}

data Functor f {
    MkFunctor:forall f.(forall a.forall b.(a->b)->f a->f b)-> -- fmap
                       Functor f
}

data Applicative f {
    MkApplicative:forall f.Functor f-> -- Functor f
                           (forall a.a->f a)-> -- pure
                           (forall a.forall b.f (a->b)->f a->f b)-> -- ap
                           Applicative f
}

data Monad m {
  MkMonad:forall m.Applicative m-> -- Applicative m
                   (forall a.forall b.m a->(a->m b)->m b)-> -- bind
                   Monad m
}

data Alternative f {
    MkAlternative:forall f.Applicative f-> -- Applicative fApplicative f
                           (forall a.f a)-> -- empty
                           (forall a.f a->f a->f a)-> -- alt
                           Alternative f
}

data IO a {
    IO:forall a.(RealWorld->Pair RealWorld a)->IO a
}

-- parser combinator
data ParsingError e {
    ParsingError:forall e.e->ParsingError e;
    GenericParsingError:forall e.List Char->ParsingError e
}

data Parser t e a {
    Parser:forall t.forall e.forall a.(List t->Either (ParsingError e) (Pair (List t) a))-> -- runParser
                                      Parser t e a
}

-- impl
data Token {
  Data:Token;
  Forall:Token;
  Dot:Token;
  Colon:Token;
  Arrow:Token;
  Semicolon:Token;

  Lambda:Token;
  Let:Token;
  Equal:Token;
  In:Token;
  Rec:Token;
  And:Token;
  Case:Token;
  Of:Token;
  Ffi:List Char->Token;

  LeftParenthesis:Token;
  RightParenthesis:Token;
  LeftBrace:Token;
  RightBrace:Token;

  Identifier:List Char->Token;

  Whitespace:List Char->Token;
  Comment:List Char->Token
}

data Position {
    Position:List Char-> -- filename
             Int-> -- row
             Int-> -- column
             Position
}

data SigMono {
    SigMonoVar:List Char->SigMono;
    SigMonoApp:SigPoly->SigPoly->SigMono
}

data SigPoly {
    SigPolyTerm:SigMono->SigPoly;
    SigPolyForall:List Char->SigPoly->SigPoly
}

data DataCtor {
    DataCtor:List Char->SigPoly->DataCtor
}

data Gadt {
    Gadt:List Char->List (List Char)->List DataCtor->Gadt
}

data Expr {
    VarExpr:List Char->Expr;
    AppExpr:Expr->Expr->Expr;
    AbsExpr:List Char->Expr->Expr;
    LetExpr:List Char->Expr->Expr->Expr;
    RecExpr:List (Pair (List Char) Expr)->Expr->Expr;
    CaseExpr:Expr->List (Pair (List Char) (Pair (List (List Char)) Expr))->Expr;
    FfiExpr:List Char->Expr
}

data Mono {
    MonoVar:Int->Mono;
    MonoApp:List Char->List Mono->Mono
}

data Poly {
    PolyTerm:Mono->Poly;
    PolyForall:Int->Poly->Poly
}

data TypeInferState {
    TypeInferState:Int-> -- nextVar
                   List (Pair Int Mono)-> -- par
                   TypeInferState
}

data TypeInfer a {
    TypeInfer:forall a.(TypeInferState->Either (List Char) (Pair TypeInferState a))-> -- runTypeInfer
                       TypeInfer a
}

data Any {
    Any:(forall a.a)->Any
}

-- ffi
let toChar {- :FfiInt -> Char -} = \c -> ffi ` ({
    char* c = BSL_RT_MALLOC(sizeof (char));
    *c = (int)$c;
    c;
}) `
in
rec toString {- :FfiString -> List Char -} = \s -> ffi ` ({
    char* s = $s;
    void* ret;
    if (!s[0]) {
        ret = $Nil;
    } else {
        ret = BSL_RT_CALL(BSL_RT_CALL($Cons, BSL_RT_CALL($toChar, s[0])), BSL_RT_CALL($toString, s + 1));
    }
    ret;
}) `
in
let toInt {- :FfiInt -> Int -} = \i -> ffi ` ({
    int* i = BSL_RT_MALLOC(sizeof (int));
    *i = (int)$i;
    i;
}) `
in

let readChar {- :IO (Maybe Char) -} = IO \r -> Pair r ffi ` ({
    int c = getchar();
    void* ret;
    if (c == -1) {
        ret = $Nothing;
    } else {
        ret = BSL_RT_CALL($Just, BSL_RT_CALL($toChar, c));
    }
    ret;
}) `
in
let writeChar {- :Char->IO Unit -} = \c -> IO \r -> Pair r ffi ` ({
    putchar(*(char*)$c);
    $Unit;
}) `
in
let runIO =
    let runIO = \r -> \io -> case io of {
        IO f -> case f r of {
            Pair r out -> out
        }
    } in runIO RealWorld
in

let undefined = ffi ` NULL ` in
let debug = \x -> let y = ffi ` puts("debug") ` in x in

-- std library
let charEq {- :Char->Char->Bool -} = \x -> \y -> ffi ` (*(char*)$x == *(char*)$y ? $True : $False) ` in
let charCompare {- :Char->Char->Ordering -} = \x -> \y -> ffi ` (*(char*)$x == *(char*)$y ? $EQ : *(char*)$x < *(char*)$y ? $LT : $GT) ` in
let intEq {- :Int->Int->Bool -} = \x -> \y -> ffi ` (*(int*)$x == *(int*)$y ? $True : $False) ` in
rec stringEq = \s1 -> \s2 -> case s1 of {
    Cons h1 t1 -> case s2 of {
        Cons h2 t2 -> case charEq h1 h2 of {
            True -> stringEq t1 t2;
            False -> False
        };
        Nil -> False
    };
    Nil -> case s2 of {
        Cons h2 t2 -> False;
        Nil -> True
    }
}
in
let listJoin =
    rec listJoinHelper = \a -> \b -> case a of {
        Cons h t -> Cons h (listJoinHelper t b);
        Nil -> b
    }
    and listJoin = \l -> case l of {
        Cons h t -> listJoinHelper h (listJoin t);
        Nil -> Nil
    }
    in
    listJoin
in
rec map = \f -> \l -> case l of {
    Cons h t -> Cons (f h) (map f t);
    Nil -> Nil
}
in
rec filter = \p -> \l -> case l of {
    Cons h t -> case p h of {
        True -> Cons h (filter p t);
        False -> filter p t
    };
    Nil -> Nil
}
in

let or = \x -> \y -> case x of {
    True -> True;
    False -> y
}
in
let not = \x -> case x of {
    True -> False;
    False -> True
}
in

let return = \m -> case m of {MkMonad a b -> case a of { MkApplicative f p a -> p } } in
let bind = \m -> case m of {MkMonad a b->b} in

let MonadIO =
    let fmap = \f -> \fa -> IO \r -> case fa of {
        IO fa -> case fa r of {
            Pair r a -> Pair r (f a)
        }
    }
    in
    let pure = \a -> IO \r -> Pair r a in
    let bind = \ma -> \f -> IO \r -> case ma of {
        IO ma -> case ma r of {
            Pair r a -> case f a of {IO f->f r}
        }
    }
    in
    let ap = \f -> \a -> bind f \f -> bind a \x -> pure (f x) in
    let FunctorIO = MkFunctor fmap in
    let ApplicativeIO = MkApplicative FunctorIO pure ap in

    MkMonad ApplicativeIO bind
in

-- parser combinator
let runParser = \p -> case p of { Parser runParser -> runParser } in
let MonadParser =
    let fmap = \f -> \p -> Parser \t -> case runParser p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            Right (Pair nt (f x))
        }
    }
    in
    let pure = \r->Parser \t -> Right (Pair t r) in
    let bind = \p -> \f -> Parser \t -> case runParser p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            runParser (f x) nt
        }
    }
    in
    let ap = \f -> \a -> bind f \f -> bind a \x -> pure (f x) in
    let FunctorParser = MkFunctor fmap in
    let ApplicativeParser = MkApplicative FunctorParser pure ap in

    MkMonad ApplicativeParser bind
in
let AlternativeParser = case MonadParser of {
    MkMonad a b ->
        let empty = Parser \t -> Left (GenericParsingError (toString ffi ` "error: empty: no matches" `)) in
        let alt = \a -> \b -> Parser \t -> case runParser a t of {
            Left err -> case runParser b t of {
                Left err' -> Left err;
                Right r -> Right r
            };
            Right r -> Right r
        }
        in
        MkAlternative a empty alt
}
in

let satisfy = \p -> Parser \t -> case t of {
    Cons h t -> case p h of {
        True -> Right (Pair t h);
        False -> Left (GenericParsingError (toString ffi ` "error: satisfy: not satisfied" `))
    };
    Nil -> Left (GenericParsingError (toString ffi ` "error: satisfy: no more token to satisfy" `))
}
in
let maybePeek = Parser \t -> case t of {
    Cons h nt -> Right (Pair t (Just h));
    Nil -> Right (Pair t Nothing)
}
in

-- impl
let tokenToString = \t -> case t of {
    Data -> toString ffi ` "data" `;
    Forall -> toString ffi ` "forall" `;
    Dot -> toString ffi ` "." `;
    Colon -> toString ffi ` ":" `;
    Arrow -> toString ffi ` "->" `;
    Semicolon -> toString ffi ` ";" `;

    Lambda -> toString ffi ` "\\" `;
    Let -> toString ffi ` "let" `;
    Equal -> toString ffi ` "=" `;
    In -> toString ffi ` "in" `;
    Rec -> toString ffi ` "rec" `;
    And -> toString ffi ` "and" `;
    Case -> toString ffi ` "case" `;
    Of -> toString ffi ` "of" `;
    Ffi s -> let sep = Cons (toChar ffi ` 36 `)
                      (Cons (toChar ffi ` 36 `) Nil) -- $$
             in
             listJoin (Cons (toString ffi ` "ffi " `)
                      (Cons sep
                      (Cons s
                      (Cons sep Nil))));

    LeftParenthesis -> toString ffi ` "(" `;
    RightParenthesis -> toString ffi ` ")" `;
    LeftBrace -> toString ffi ` "{" `;
    RightBrace -> toString ffi ` "}" `;

    Identifier s -> s;

    Whitespace s -> s;
    Comment s -> s
}
in

let gadtsToString =
    rec monoToString = \m -> case m of {
        SigMonoVar t -> t;
        SigMonoApp t1 t2 -> case stringEq (polyToString t1) (toString ffi ` "->" `) of {
            True ->
                listJoin (Cons (polyToString t2)
                         (Cons (toString ffi ` " ->" `) Nil));
            False ->
                listJoin (Cons (toString ffi ` "(" `)
                         (Cons (polyToString t1)
                         (Cons (toString ffi ` " " `)
                         (Cons (polyToString t2)
                         (Cons (toString ffi ` ")" `) Nil)))))
        }
    }
    and polyToString = \p -> case p of {
        SigPolyForall t p -> listJoin (Cons (toString ffi ` "forall " `)
                                      (Cons t
                                      (Cons (toString ffi ` "." `)
                                      (Cons (polyToString p) Nil))));
        SigPolyTerm m -> monoToString m
    }
    in
    let dataCotrToString = \dataCotr -> case dataCotr of {
        DataCtor ctor sig -> listJoin (Cons (toString ffi ` "  "` )
                                      (Cons ctor
                                      (Cons (toString ffi ` ":"` )
                                      (Cons (polyToString sig)
                                      (Cons (toString ffi ` ";\n"` ) Nil)))))
    }
    in
    let gadtToString = \gadt -> case gadt of {
        Gadt c ts dataCotrs ->
            listJoin (Cons (toString ffi ` "data " `)
                     (Cons c
                     (Cons (listJoin (map (\t -> listJoin (Cons (toString ffi ` " " `) (Cons t Nil))) ts))
                     (Cons (toString ffi ` " where {\n" `)
                     (Cons (listJoin (map dataCotrToString dataCotrs))
                     (Cons (toString ffi ` "}\n" `) Nil))))))
    }
    in
    \gadts -> listJoin (map (\gadt -> gadtToString gadt) gadts)
in
rec exprToString = \e -> case e of {
    VarExpr v -> v;
    AppExpr e1 e2 -> listJoin (Cons (toString ffi ` "(" `)
                              (Cons (exprToString e1)
                              (Cons (toString ffi ` ") (" `)
                              (Cons (exprToString e2)
                              (Cons (toString ffi ` ")" `) Nil)))));
    AbsExpr x e -> listJoin (Cons (toString ffi ` "(\\" `)
                            (Cons x
                            (Cons (toString ffi ` " -> " `)
                            (Cons (exprToString e)
                            (Cons (toString ffi ` ")" `) Nil)))));
    LetExpr x e1 e2 -> listJoin (Cons (toString ffi ` "(let " `)
                                (Cons x
                                (Cons (toString ffi ` " = " `)
                                (Cons (exprToString e1)
                                (Cons (toString ffi ` " in " `)
                                (Cons (exprToString e2)
                                (Cons (toString ffi ` ")" `) Nil)))))));
    RecExpr xes e -> case xes of {
        Cons xe xes ->
            let xeToString = \xe -> case xe of {
                Pair x e -> listJoin
                    (Cons x
                    (Cons (toString ffi ` " = " `)
                    (Cons (exprToString e) Nil)))
            }
            in
            listJoin (Cons (toString ffi ` "(rec " `)
                     (Cons (listJoin (Cons (xeToString xe) (map (\xe -> listJoin (Cons (toString ffi ` " and " `) (Cons (xeToString xe) Nil))) xes)))
                     (Cons (toString ffi ` " in " `)
                     (Cons (exprToString e)
                     (Cons (toString ffi ` ")" `) Nil)))));
        Nil -> toString ffi ` "unreachable" `
    };
    CaseExpr e pes -> case pes of {
        Cons pe pes ->
            let peToString = \pe -> case pe of {
                Pair c dse -> case dse of {
                    Pair ds e ->
                        listJoin
                            (Cons c
                            (Cons (listJoin (map (\s -> listJoin (Cons (toString ffi ` " " `) (Cons s Nil))) ds))
                            (Cons (toString ffi ` " -> " `)
                            (Cons (exprToString e) Nil))))
                }
            }
            in
            listJoin
                (Cons (toString ffi ` "case " `)
                (Cons (exprToString e)
                (Cons (toString ffi ` " of {" `)
                (Cons (listJoin (Cons (peToString pe) (map (\pe -> listJoin (Cons (toString ffi ` "; " `) (Cons (peToString pe) Nil))) pes)))
                (Cons (toString ffi ` "}" `) Nil)))));
        Nil -> toString ffi ` "unreachable" `
    };
    FfiExpr s ->
        let sep = Cons (toChar ffi ` 36 `)
                 (Cons (toChar ffi ` 36 `) Nil) -- $$
        in
        listJoin
            (Cons (toString ffi ` "ffi " `)
            (Cons sep
            (Cons (toString ffi ` " " `)
            (Cons s
            (Cons (toString ffi ` " " `)
            (Cons sep Nil))))))
}
in

rec typeToString = \t -> Cons (toChar ffi ` 't' `) (toString ffi ` ({
    char* s = BSL_RT_MALLOC(11);
    sprintf(s, "%d", *(int*)$t);
    s;
}) `)
and monoToString = \t -> case t of {
    MonoVar t -> typeToString t;
    MonoApp c ts -> case stringEq c (toString ffi ` "->" `) of {
        True -> case ts of {
            Nil -> toString ffi ` "unreachable" `;
            Cons t1 ts -> case ts of {
                Nil -> toString ffi ` "unreachable" `;
                Cons t2 ts ->
                    listJoin (Cons (toString ffi ` "(" `)
                             (Cons (monoToString t1)
                             (Cons (toString ffi ` "->" `)
                             (Cons (monoToString t2)
                             (Cons (toString ffi ` ")" `) Nil)))))
            }
        };
        False ->
            rec monoListToString = \ts -> case ts of {
                Nil -> Nil;
                Cons h t ->
                    listJoin (Cons (toString ffi ` " " `)
                             (Cons (monoToString h)
                             (Cons (monoListToString t) Nil)))
            }
            in
            listJoin (Cons (toString ffi ` "(" `)
                     (Cons c
                     (Cons (monoListToString ts)
                     (Cons (toString ffi ` ")" `) Nil))))
    }
}
and polyToString = \t -> case t of {
    PolyTerm t -> monoToString t;
    PolyForall t p -> listJoin (Cons (toString ffi ` "forall " `)
                               (Cons (typeToString t)
                               (Cons (toString ffi ` "." `)
                               (Cons (polyToString p) Nil))))
}
in

let lex =
    let bind = bind MonadParser in
    let return = return MonadParser in
    let empty = case AlternativeParser of {
        MkAlternative a e alt -> e
    }
    in
    rec many = \x -> Parser \t -> case runParser x t of {
        Left e -> Right (Pair t Nil);
        Right r -> case r of { Pair nt h ->
            case runParser (many x) nt of {
                Left e -> Left e;
                Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
            }
        }
    }
    in
    let some = \x -> bind x \h -> bind (many x) \t -> return (Cons h t) in
    let alt = case AlternativeParser of { MkAlternative a e alt -> alt } in
    let eof = Parser \t -> case t of {
        Nil -> Right (Pair Nil Unit);
        Cons h t -> Left (ParsingError (toString ffi ` "eof" `))
    }
    in
    let matchChar = \c -> satisfy (charEq c) in
    rec matchString = \s -> case s of {
        Cons h t -> bind (satisfy (charEq h)) \h ->
                    bind (matchString t) \t ->
                         return (Cons h t);
        Nil -> return Nil
    }
    in
    let matchNewline = alt (matchString (toString ffi ` "\n" `))
                      (alt (matchString (toString ffi ` "\r\n" `))
                           (matchString (toString ffi ` "\r" `)))
    in
    let matchWhitespace = alt (matchString (toString ffi ` " " `))
                              (matchString (toString ffi ` "\t" `))
    in
    let elem = \e ->
        rec elem = \l -> case l of {
            Cons h t -> case charEq h e of {
                True -> True;
                False -> elem t
            };
            Nil -> False
        }
        in
        elem
    in

    let sep = bind maybePeek \c -> case c of {
        Nothing -> return Unit;
        Just c -> case elem c (toString ffi ` "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789'" `) of {
            True -> empty;
            False -> return Unit
        }
    }
    in
    let data_ = bind (matchString (toString ffi ` "data" `)) \_ -> bind sep \_ -> return Data in
    let forall_ = bind (matchString (toString ffi ` "forall" `)) \_ -> bind sep  \_ -> return Forall in
    let dot = bind (matchString (toString ffi ` "." `)) \_ -> return Dot in
    let colon = bind (matchString (toString ffi ` ":" `)) \_ -> return Colon in
    let arrow = bind (matchString (toString ffi ` "->" `)) \_ -> return Arrow in
    let semicolon = bind (matchString (toString ffi ` ";" `)) \_ -> return Semicolon in

    let lambda = bind (matchString (toString ffi ` "\\" `)) \_ -> return Lambda in
    let let_ = bind (matchString (toString ffi ` "let" `)) \_ -> bind sep  \_ -> return Let in
    let equal = bind (matchString (toString ffi ` "=" `)) \_ -> return Equal in
    let in_ = bind (matchString (toString ffi ` "in" `)) \_ -> bind sep \_ -> return In in
    let rec_ = bind (matchString (toString ffi ` "rec" `)) \_ -> bind sep  \_ -> return Rec in
    let and_ = bind (matchString (toString ffi ` "and" `)) \_ -> bind sep  \_ -> return And in
    let case_ = bind (matchString (toString ffi ` "case" `)) \_ -> bind sep  \_ -> return Case in
    let of_ = bind (matchString (toString ffi ` "of" `)) \_ -> bind sep  \_ -> return Of in
    let ffi_ = bind (matchString (toString ffi ` "ffi" `)) \_ ->
               bind (some (alt matchNewline matchWhitespace)) \_ ->
               bind (some (satisfy \c -> not (elem c (toString ffi ` " \t\n\r" `)))) \sep ->
               bind (let matchSep = bind (matchString sep) \_ -> return Nothing in
                     let matchAny = bind (satisfy \c -> True) \c -> return (Just c) in
                     rec t = \u ->
                        bind (alt matchSep matchAny) \c -> case c of {
                            Nothing -> return Nil;
                            Just c -> bind (t Unit) \s -> return (Cons c s)
                        }
                     in
                     t Unit) \s ->
                    return (Ffi s) in
    let leftParenthesis = bind (matchString (toString ffi ` "(" `)) \_ -> return LeftParenthesis in
    let rightParenthesis = bind (matchString (toString ffi ` ")" `)) \_ -> return RightParenthesis in
    let leftBrace = bind (matchString (toString ffi ` "{" `)) \_ -> return LeftBrace in
    let rightBrace = bind (matchString (toString ffi ` "}" `)) \_ -> return RightBrace in
    let identifier = bind (satisfy \c -> elem c (toString ffi ` "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_" `)) \h ->
                     bind (many (satisfy \c -> elem c (toString ffi ` "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789'" `))) \t ->
                          return (Identifier (Cons h t))
    in
    let whitespace = bind (some (alt matchWhitespace matchNewline)) \s ->
                          return (Whitespace (listJoin s))
    in
    let comment = alt (bind (matchString (toString ffi ` "--" `)) \s1 ->
                       bind (many (satisfy (\c -> not (elem c (toString ffi ` "\n\r" `))))) \s2 ->
                            return (Comment (listJoin (Cons s1 (Cons s2 Nil)))))
                      (bind (matchString (toString ffi ` "{-" `)) \s1 ->
                       bind (many (alt (satisfy \c -> not (charEq c (toChar ffi ` '-' `))) (bind (matchChar (toChar ffi ` '-' `)) \c ->
                                                                                            bind maybePeek \p -> case p of {
                                                                                                Nothing -> empty;
                                                                                                Just p -> case charEq p (toChar ffi ` '}' `) of {
                                                                                                    True -> empty;
                                                                                                    False -> return c
                                                                                                }
                                                                                            }))) \s2 ->
                       bind (matchString (toString ffi ` "-}" `)) \s3 ->
                            return (Comment (listJoin (Cons s1 (Cons s2 (Cons s3 Nil))))))
    in

    let skip = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> True;
        Comment s -> True
    }
    in

    bind (many (alt data_
               (alt forall_
               (alt dot
               (alt colon
               (alt arrow
               (alt semicolon
               (alt lambda
               (alt let_
               (alt equal
               (alt in_
               (alt rec_
               (alt and_
               (alt case_
               (alt of_
               (alt ffi_
               (alt whitespace
               (alt comment
               (alt leftParenthesis
               (alt rightParenthesis
               (alt leftBrace
               (alt rightBrace
                    identifier)))))))))))))))))))))) \tokens ->
    bind eof \_ ->
         return (filter (\t -> not (skip t)) tokens)
in

let parse =
    let bind = bind MonadParser in
    let return = return MonadParser in
    let empty = case AlternativeParser of {
        MkAlternative a e alt -> e
    }
    in
    rec many = \x -> Parser \t -> case runParser x t of {
        Left e -> Right (Pair t Nil);
        Right r -> case r of { Pair nt h ->
            case runParser (many x) nt of {
                Left e -> Left e;
                Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
            }
        }
    }
    in
    let some = \x -> bind x \h -> bind (many x) \t -> return (Cons h t) in
    let alt = case AlternativeParser of { MkAlternative a e alt -> alt } in
    let unreachable = Parser \t -> Left (ParsingError (toString ffi ` "unreachable" `)) in
    let eof = Parser \t -> case t of {
        Nil -> Right (Pair Nil Unit);
        Cons h t -> Left (ParsingError (toString ffi ` "eof" `))
    }
    in

    let isData = \t -> case t of {
        Data -> True;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isForall = \t -> case t of {
        Data -> False;
        Forall -> True;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isDot = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> True;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isColon = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> True;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isArrow = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> True;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isSemicolon = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> True;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isLambda = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> True;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isLet = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> True;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isEqual = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> True;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isIn = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> True;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isRec = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> True;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isAnd = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> True;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isCase = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> True;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isOf = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> True;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let getFfi = \t -> case t of {
        Data -> Nothing;
        Forall -> Nothing;
        Dot -> Nothing;
        Colon -> Nothing;
        Arrow -> Nothing;
        Semicolon -> Nothing;

        Lambda -> Nothing;
        Let -> Nothing;
        Equal -> Nothing;
        In -> Nothing;
        Rec -> Nothing;
        And -> Nothing;
        Case -> Nothing;
        Of -> Nothing;
        Ffi s -> Just s;

        LeftParenthesis -> Nothing;
        RightParenthesis -> Nothing;
        LeftBrace -> Nothing;
        RightBrace -> Nothing;

        Identifier s -> Nothing;

        Whitespace s -> Nothing;
        Comment s -> Nothing
    }
    in
    let isLeftParenthesis = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> True;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isRightParenthesis = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> True;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isLeftBrace = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> True;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isRightBrace = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> True;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let getIdentifier = \t -> case t of {
        Data -> Nothing;
        Forall -> Nothing;
        Dot -> Nothing;
        Colon -> Nothing;
        Arrow -> Nothing;
        Semicolon -> Nothing;

        Lambda -> Nothing;
        Let -> Nothing;
        Equal -> Nothing;
        In -> Nothing;
        Rec -> Nothing;
        And -> Nothing;
        Case -> Nothing;
        Of -> Nothing;
        Ffi s -> Nothing;

        LeftParenthesis -> Nothing;
        RightParenthesis -> Nothing;
        LeftBrace -> Nothing;
        RightBrace -> Nothing;

        Identifier s -> Just s;

        Whitespace s -> Nothing;
        Comment s -> Nothing
    }
    in

    let data_ = satisfy isData in
    let forall_ = satisfy isForall in
    let dot = satisfy isDot in
    let colon = satisfy isColon in
    let arrow = satisfy isArrow in
    let semicolon = satisfy isSemicolon in
    let lambda = satisfy isLambda in
    let let_ = satisfy isLet in
    let equal = satisfy isEqual in
    let in_ = satisfy isIn in
    let rec_ = satisfy isRec in
    let and_ = satisfy isAnd in
    let case_ = satisfy isCase in
    let of_ = satisfy isOf in
    let ffi_ = bind (satisfy \t -> case getFfi t of {
        Nothing -> False;
        Just x -> True
    }) \x -> case getFfi x of {
        Nothing -> unreachable;
        Just x -> return x
    }
    in
    let leftParenthesis = satisfy isLeftParenthesis in
    let rightParenthesis = satisfy isRightParenthesis in
    let leftBrace = satisfy isLeftBrace in
    let rightBrace = satisfy isRightBrace in
    let identifier = bind (satisfy \t -> case getIdentifier t of {
        Nothing -> False;
        Just x -> True
    }) \x -> case getIdentifier x of {
        Nothing -> unreachable;
        Just x -> return x
    }
    in

    let isApp1 = bind maybePeek \x -> case x of {
        Nothing -> return False;
        Just x -> return (or (isLambda x) (or (isLet x) (isRec x)))
    }
    in
    let isApp2 =
        let isIdentifier = \x ->case getIdentifier x of {
            Nothing -> False;
            Just s -> True
        }
        in
        let isFfi = \x ->case getFfi x of {
            Nothing -> False;
            Just s -> True
        }
        in
        bind maybePeek \x -> case x of {
            Nothing -> return False;
            Just x -> return (or (isIdentifier x) (or (isLeftParenthesis x) (or (isCase x) (isFfi x))))
    }
    in

    let sig =
        let forall_ =
            bind forall_ \_ ->
            bind identifier \t ->
            bind dot \_ ->
                 return (Just t)
        in
        rec poly_ = \u ->
            let poly_ = \u ->
                bind (alt (satisfy (\t -> case getIdentifier t of {Just _ -> True; Nothing -> False})) leftParenthesis) \t -> case getIdentifier t of {
                    Just c -> return (SigPolyTerm (SigMonoVar c));
                    Nothing ->
                        bind (poly u) \t ->
                        bind rightParenthesis \_ ->
                             return t
                }
            in
            rec app = \c -> \ts -> case ts of {
                Cons h t -> app (SigPolyTerm (SigMonoApp c h)) t;
                Nil -> c
            }
            in
            bind (poly_ u) \c ->
            bind (many (poly_ u)) \ts ->
                 return (app c ts)
        and mono = \u ->
            bind (poly_ u) \t1 ->
            bind maybePeek \t -> case t of {
                Just t -> case isArrow t of {
                    True ->
                        bind arrow \_ ->
                        bind (mono u) \t2 ->
                             return (SigPolyTerm (SigMonoApp (SigPolyTerm (SigMonoApp (SigPolyTerm (SigMonoVar (toString ffi ` "->" `))) t1)) t2));
                    False -> return t1
                };
                Nothing -> return t1
            }
        and poly = \u ->
            bind (alt forall_ (return Nothing)) \t -> case t of {
                Just t ->
                    bind (poly u) \poly ->
                         return (SigPolyForall t poly);
                Nothing ->
                    bind (mono u) \mono ->
                        return mono
            }
        in
        poly Unit
    in
    let dataCtor =
        bind identifier \ctor ->
        bind colon \_ ->
        bind sig \sig ->
             return (DataCtor ctor sig)
    in
    let dataCtors =
        rec dataCtors = \u ->
            bind dataCtor \d ->
                 alt (
                     bind semicolon \_ ->
                     bind (dataCtors u) \ds ->
                         return (Cons d ds)
                 ) (return (Cons d Nil))
        in
        alt (dataCtors Unit) (return Nil)
    in
    let gadts = many (
        bind data_ \_ ->
        bind identifier \c ->
        bind (many identifier) \ts ->
        bind leftBrace \_ ->
        bind dataCtors \ctors ->
        bind rightBrace \_ ->
             return (Gadt c ts ctors)
    )
    in
    rec expr = \u -> alt (absExpr u)
                    (alt (letExpr u)
                    (alt (recExpr u) (appExpr1 u)))
    and expr_ = \u -> alt (varExpr u)
                     (alt (bind leftParenthesis \_ ->
                           bind (expr u) \e ->
                           bind rightParenthesis \_ ->
                                return e)
                     (alt (caseExpr u)
                          (ffiExpr u)))
    and varExpr = \u ->
        bind identifier \x ->
             return (VarExpr x)
    and caseExpr = \u ->
        let peExpr =
            bind identifier \c ->
            bind (many identifier) \ds ->
            bind arrow \_ ->
            bind (expr u) \e ->
                 return (Pair c (Pair ds e))
        in
        bind case_ \_ ->
        bind (expr u) \e ->
        bind of_ \_ ->
        bind leftBrace \_ ->
        bind peExpr \pe ->
        bind (many (bind semicolon \_ -> peExpr)) \pes ->
        bind rightBrace \_ ->
             return (CaseExpr e (Cons pe pes))
    and ffiExpr = \u ->
        bind ffi_ \s ->
             return (FfiExpr s)
    and appExpr1 = \u ->
        bind (appExpr2 u) \e1 ->
        bind isApp1 \b -> case b of {
            False -> return e1;
            True ->  bind (expr u) \e2 ->
                         return (AppExpr e1 e2)
        }
    and appExpr2 = \u ->
        let expr =
            bind isApp2 \b -> case b of {
                False -> empty;
                True -> expr_ u
            }
        in
        rec toApp = \e -> \es -> case es of {
            Cons h t -> toApp (AppExpr e h) t;
            Nil -> e
        }
        in
        bind expr \e ->
        bind (many expr) \es->
             return (toApp e es)
    and absExpr = \u ->
        bind lambda \_ ->
        bind identifier \x ->
        bind arrow \_ ->
        bind (expr u) \e ->
             return (AbsExpr x e)
    and letExpr = \u ->
        bind let_ \_ ->
        bind identifier \x ->
        bind equal \_ ->
        bind (expr u) \e1 ->
        bind in_ \_ ->
        bind (expr u) \e2 ->
            return (LetExpr x e1 e2)
    and recExpr = \u ->
        let xeExpr =
            bind identifier \x ->
            bind equal \_ ->
            bind (expr u) \e ->
                 return (Pair x e)
        in
        bind rec_ \_ ->
        bind xeExpr \xe ->
        bind (many (bind and_ \_ -> xeExpr)) \xes ->
        bind in_ \_ ->
        bind (expr u) \e ->
             return (RecExpr (Cons xe xes) e)
    in

    bind gadts \gadts ->
    bind (expr Unit) \e ->
    bind eof \_ ->
         return (Pair gadts e)
in

let typeInfer = \e ->
    let gadts = case e of { Pair gadts _ -> gadts } in
    let e = case e of { Pair _ e -> e} in
    let bind = \m -> \f -> TypeInfer \s -> case m of {
        TypeInfer runTypeInfer -> case runTypeInfer s of {
            Left e -> Left e;
            Right r -> case r of {
                Pair ns x -> case f x of {
                    TypeInfer runTypeInfer -> runTypeInfer ns
                }
            }
        }
    }
    in
    let return = \x -> TypeInfer \s -> Right (Pair s x) in
    let fail = \s -> TypeInfer \st -> Left s in
    let runTypeInfer = \infer -> case infer of {
        TypeInfer runTypeInfer -> case runTypeInfer (TypeInferState (toInt ffi ` 0 `) Nil) of {
            Left e -> Left e;
            Right r -> case r of {
                Pair s t -> Right t
            }
        }
    }
    in
    let elem = \e ->
        rec elem = \l -> case l of {
            Cons h t -> case intEq h e of {
                True -> True;
                False -> elem t
            };
            Nil -> False
        }
        in
        elem
    in
    let diff = \l1 -> \l2 ->
        rec diff = \l1 -> case l1 of {
            Cons h t -> case elem h l2 of {
                True -> diff t;
                False -> Cons h (diff t)
            };
            Nil -> Nil
        }
        in diff l1
    in
    rec uniq = \l -> case l of {
        Cons h t -> case elem h t of {
            True -> uniq t;
            False -> Cons h (uniq t)
        };
        Nil -> Nil
    }
    in
    let lookup = \x ->
        rec lookup = \m -> case m of {
            Cons h t -> case h of {
                Pair k v -> case stringEq k x of{
                    True -> Just v;
                    False -> lookup t
                }
            };
            Nil -> Nothing
        }
        in lookup
    in
    let insert = \k -> \v -> \m -> Cons (Pair k v) m in
    let newVar = TypeInfer \s -> case s of {
        TypeInferState nextVar par ->
            let inc = \x -> toInt ffi ` *(int*)$x + 1 ` in
            Right (Pair (TypeInferState (inc nextVar) par) nextVar)
    }
    in
    let find = \x -> TypeInfer \s -> case s of {
        TypeInferState nextVar par ->
            rec find = \x -> \par' -> case par' of {
                Cons h t -> case h of {
                    Pair k v -> case intEq k x of {
                        True -> case v of {
                            MonoVar t -> find t par;
                            MonoApp c ts -> v
                        };
                        False -> find x t
                    }
                };
                Nil -> MonoVar x
            }
            in
            case x of {
                MonoVar t -> Right (Pair s (find t par));
                MonoApp c ts -> Right (Pair s x)
            }
    }
    in
    let inst =
        let apply = \s ->
            rec apply = \m -> bind (find m) \m -> case m of {
                MonoVar t ->
                    rec lookup = \m -> case m of {
                        Cons mh mt -> case mh of {
                            Pair k v -> case intEq k t of {
                                True -> v;
                                False -> lookup mt
                            }
                        };
                        Nil -> t
                    }
                    in
                    return (MonoVar (lookup s));
                MonoApp c ts ->
                    rec apply' = \ts -> case ts of {
                        Cons h t ->
                            bind (apply h) \h ->
                            bind (apply' t) \t ->
                                 return (Cons h t);
                        Nil -> return Nil
                    }
                    in
                    bind (apply' ts) \ts ->
                         return (MonoApp c ts)
            }
            in
            apply
        in
        rec inst = \s -> \p -> case p of {
            PolyForall x p ->
                bind newVar \t ->
                     inst (Cons (Pair x t) s) p;
            PolyTerm m -> apply s m
        }
        in
        inst Nil
    in
    let occ = \x ->
        rec occ = \y -> bind (find y) \y -> case y of {
            MonoVar t -> case intEq x t of {
                True -> fail (toString ffi ` "occ" `);
                False -> return Unit
            };
            MonoApp c ts ->
                rec occ' = \ts -> case ts of {
                    Cons h t -> bind (occ h) \_ ->
                                     occ' t;
                    Nil -> return Unit
                }
                in occ' ts
        }
        in
        occ
    in
    let setPar = \x -> \y -> bind (occ x y) \_ -> TypeInfer \s -> case s of {
        TypeInferState nextVar par -> Right (Pair (TypeInferState nextVar (Cons (Pair x y) par)) Unit)
    }
    in
    rec ftv = \p -> case p of {
        PolyForall t p -> bind (ftv p) \f -> return (diff f (Cons t Nil));
        PolyTerm m ->
            rec ftv' = \m -> bind (find m) \m -> case m of {
                MonoVar t -> return (Cons t Nil);
                MonoApp c ts ->
                    rec ftv'' = \ts -> case ts of {
                        Cons h t ->
                            bind (ftv' h) \h ->
                            bind (ftv'' t) \t ->
                                 return (listJoin (Cons h (Cons t Nil)));
                        Nil -> return Nil
                    }
                    in ftv'' ts
            }
            in
            ftv' m
    }
    in
    rec ctxFtv = \ctx -> case ctx of {
        Cons h t -> case h of {
            Pair k v -> bind (ftv v) \h ->
                        bind (ctxFtv t) \t ->
                             return (listJoin (Cons h (Cons t Nil)))
        };
        Nil -> return Nil
    }
    in
    let gen = \ctx -> \m ->
        let toPoly = \m ->
            rec toPoly = \f -> case f of {
                Cons h t -> PolyForall h (toPoly t);
                Nil -> PolyTerm m
            }
            in
            toPoly
        in
        bind (ctxFtv ctx) \ctxf ->
        bind (ftv (PolyTerm m)) \mf ->
             let fa = uniq (diff mf ctxf) in
             return (toPoly m mf)
    in
    rec unify = \x -> \y ->
        bind (find x) \x ->
        bind (find y) \y ->
             case x of {
                 MonoVar t -> case y of {
                     MonoVar s -> case intEq t s of {
                        True -> return Unit;
                        False -> setPar t y
                     };
                     MonoApp cs s -> setPar t y
                 };
                 MonoApp ct t -> case y of {
                     MonoVar s -> setPar s x;
                     MonoApp cs s -> case stringEq ct cs of {
                        False -> fail (toString ffi ` "unify: failed" `);
                        True ->
                            rec unify' = \t -> \s -> case t of {
                                Cons th tt -> case s of {
                                    Cons sh st ->
                                        bind (unify th sh) \_ ->
                                             unify' tt st;
                                    Nil -> fail (toString ffi ` "unify: failed" `)
                                };
                                Nil -> case s of {
                                    Cons sh st -> fail (toString ffi ` "unify: failed" `);
                                    Nil -> return Unit
                                }
                            }
                            in
                            unify' t s
                     }
                 }
             }
    in
    rec typeInfer = \ctx -> \e -> case e of {
        VarExpr v -> case lookup v ctx of {
            Just t -> inst t;
            Nothing -> fail (toString ffi ` "not found" `)
        };
        AppExpr e1 e2 ->
            bind (typeInfer ctx e1) \t1 ->
            bind (typeInfer ctx e2) \t2 ->
            bind newVar \t3 ->
            bind (unify t1 (MonoApp (toString ffi ` "->" `) (Cons t2 (Cons (MonoVar t3) Nil)))) \_ ->
                 return (MonoVar t3);
        AbsExpr x e ->
            bind newVar \tx ->
                 let ctx' = insert x (PolyTerm (MonoVar tx)) ctx in
            bind (typeInfer ctx' e) \te->
                 return (MonoApp (toString ffi ` "->" `) (Cons (MonoVar tx) (Cons te Nil)));
        LetExpr x e1 e2 ->
            bind (typeInfer ctx e1) \t1 ->
            bind (gen ctx t1) \p1 ->
                 typeInfer (Cons (Pair x p1) ctx) e2;
        -- TODO: implement type infer for rec/case
        RecExpr xes e ->
            rec xets = \xes -> case xes of {
                Cons xe xes -> case xe of {
                    Pair x e ->
                        bind newVar \tx ->
                        bind (xets xes) \ctx ->
                             return (Cons (Pair x (Pair e (MonoVar tx))) ctx)
                };
                Nil -> return Nil
            }
            in
            let newCtx = \ctx' ->
                rec infer = \xets -> case xets of {
                    Cons xet xets -> case xet of {
                        Pair x et -> case et of {
                            Pair e t ->
                                bind (typeInfer ctx' e) \t' ->
                                bind (unify t t') \_ ->
                                     infer xets
                        }
                    };
                    Nil -> return Unit
                }
                in
                rec newCtx = \xets -> case xets of {
                    Cons xet xets -> case xet of {
                        Pair x et -> case et of {
                            Pair e t ->
                                bind (gen ctx t) \t ->
                                bind (newCtx xets) \ctx ->
                                     return (Cons (Pair x t) ctx)
                        }
                    };
                    Nil -> return ctx
                }
                in
                \xets -> bind (infer xets) \_ ->
                              newCtx xets
            in
            bind (xets xes) \xets ->
                 let xts = map (\xet -> case xet of {
                    Pair x et -> case et of {
                        Pair e t -> Pair x (PolyTerm t)
                    }
                 }) xets
                 in
                 let ctx' = listJoin (Cons xts (Cons ctx Nil)) in
            bind (newCtx ctx' xets) \ctx ->
                 typeInfer ctx e;
        CaseExpr e pes -> bind (typeInfer ctx e) \t ->
                               return t;
        FfiExpr s -> bind newVar \tx ->
                          return (MonoVar tx)
    }
    in
    rec sub = \x -> bind (find x) \x -> case x of {
        MonoVar t ->  return x;
        MonoApp c ts ->
            rec sub' = \ts -> case ts of {
                Cons h t ->
                    bind (sub h) \h ->
                    bind (sub' t) \t ->
                         return (Cons h t);
                Nil -> return Nil
            }
            in
            bind (sub' ts) \ts ->
                 return (MonoApp c ts)
    }
    in
    let builtin =
        let stringType = MonoApp (toString ffi ` "List" `) (Cons (MonoApp (toString ffi ` "Char" `) Nil) Nil) in
        let unitType = MonoApp (toString ffi ` "Unit" `) Nil in
        let ioUnitType = MonoApp (toString ffi ` "IO" `) (Cons unitType Nil) in
        let writeString = Pair (toString ffi ` "writeString" `)
                               (PolyTerm (MonoApp (toString ffi ` "->" `) (Cons stringType (Cons ioUnitType Nil))))
        in
        let str = Pair (toString ffi ` "str" `) (PolyTerm stringType)
        in
        Cons writeString (Cons str Nil)
    in
    runTypeInfer (
        bind (typeInfer builtin e) \t ->
             sub t
    )
in

let eval =
    let bind = bind MonadIO in
    let return = return MonadIO in
    let lookup = \x ->
        rec lookup = \m -> case m of {
            Cons h t -> case h of {
                Pair k v -> case stringEq k x of{
                    True -> Just v;
                    False -> lookup t
                }
            };
            Nil -> Nothing
        }
        in lookup
    in
    let unreachable = ffi ` NULL ` in
    let pureEval =
        let nextX = \m ->
            rec nextX = \x -> case lookup x m of {
                Just x -> nextX (Cons (toChar ffi ` 36 `) x);
                Nothing -> x
            }
            in
            nextX
        in
        rec sub = \m -> \e -> case e of {
            VarExpr x -> case lookup x m of {
                Just v -> VarExpr v;
                Nothing -> e
            };
            AppExpr e1 e2 -> AppExpr (sub m e1) (sub m e2);
            AbsExpr x e ->
                let x' = nextX m x in
                AbsExpr x' (sub (Cons (Pair x x') m) e);
            LetExpr x e1 e2 ->
                let x' = nextX m x in
                LetExpr x' (sub m e1) (sub (Cons (Pair x x') m) e2);
            RecExpr xes e ->
                rec newM = \xes -> case xes of {
                    Cons xe xes -> case xe of {
                        Pair x e ->
                            let x' = nextX m x in
                            Cons (Pair x x') (newM xes)
                    };
                    Nil -> m
                }
                in
                let newM = newM xes in
                rec newXes = \xes -> case xes of {
                    Cons xe xes -> case xe of {
                        Pair x e -> Cons (Pair (case lookup x newM of {
                            Nothing -> unreachable;
                            Just x -> x
                        }) (sub newM e)) (newXes xes)
                    };
                    Nil -> Nil
                }
                in
                let newXes = newXes xes in
                RecExpr newXes (sub newM e);
            CaseExpr e' pes -> e;
            FfiExpr s -> e
        }
        in
        rec eval = \ctx -> \e -> case e of {
            VarExpr x -> case lookup x ctx of {
                Just v -> sub (map (\x -> case x of { Pair x e -> Pair x x }) ctx) v;
                Nothing -> e
            };
            AppExpr e1 e2 ->
                let e1 = eval ctx e1 in
                let e2 = eval ctx e2 in
                case e1 of {
                    VarExpr x -> AppExpr e1 e2;
                    AppExpr e1' e2' -> AppExpr e1 e2;
                    AbsExpr x e -> eval (Cons (Pair x e2) ctx) e;
                    LetExpr x e1 e2 -> unreachable;
                    RecExpr xes e -> AppExpr e1 e2;
                    CaseExpr e pes -> AppExpr e1 e2;
                    FfiExpr s -> AppExpr e1 e2
                };
            AbsExpr x e -> AbsExpr x (eval (Cons (Pair x (VarExpr x)) ctx) e);
            LetExpr x e1 e2 -> eval (Cons (Pair x (eval ctx e1)) ctx) e2;
            RecExpr xes e ->
                rec newCtx = \xes -> case xes of {
                    Cons xe xes -> case xe of {
                        Pair x e -> Cons (Pair x (VarExpr x)) (newCtx xes)
                    };
                    Nil -> ctx
                }
                in
                let ctx' = newCtx xes in
                rec newXes = \xes -> case xes of {
                    Cons xe xes -> case xe of {
                        Pair x e -> Cons (Pair x (eval ctx' e)) (newXes xes)
                    };
                    Nil -> Nil
                }
                in
                RecExpr (newXes xes) (eval ctx' e);
            CaseExpr e' pes -> e;
            FfiExpr s -> e
        }
        in
        \e -> eval Nil (sub Nil e)
    in
    let toAny = \x -> Any ffi ` $x ` in
    let fromAny = \x -> case x of { Any x -> x } in
    let unreachable = Any ffi ` NULL ` in
    rec eval = \ctx -> \e -> case e of {
        VarExpr x -> case lookup x ctx of {
            Just v -> v;
            Nothing -> unreachable
        };
        AppExpr e1 e2 ->
            let e1 = eval ctx e1 in
            let e2 = eval ctx e2 in
            toAny ((fromAny e1) (fromAny e2));
        AbsExpr x e -> toAny \v -> eval (Cons (Pair x v) ctx) e;
        LetExpr x e1 e2 -> eval (Cons (Pair x (eval ctx e1)) ctx) e2;
        RecExpr xes e ->
            rec ctx' = \xes' -> case xes' of {
                Cons xe xes'' -> case xe of {
                    Pair x e -> Cons (Pair x (toAny \v -> fromAny (eval (ctx' xes) e) v)) (ctx' xes'')
                };
                Nil -> ctx
            }
            in
            eval (ctx' xes) e;
        CaseExpr e pes -> toAny undefined;
        FfiExpr s -> toAny undefined
    }
    in
    rec writeString = \s -> case s of {
        Cons h t -> bind (writeChar h) \u ->
                         writeString t;
        Nil -> return Unit
    }
    in
    let builtin =
        let writeString =
            Pair (toString ffi ` "writeString" `) (toAny writeString)
        in
        let str = Pair (toString ffi ` "str" `) (toAny (toString ffi ` "hello world!\n" `)) in
        Cons writeString (Cons str Nil)
    in
    \e ->
             let gadts = case e of { Pair gadts _ -> gadts } in
             let e = case e of { Pair _ e -> pureEval e } in
             let r = fromAny (eval builtin e) in
        bind (writeString (toString ffi ` "expr: " `)) \_ ->
        bind (writeString (exprToString e)) \_ ->
        bind (writeString (toString ffi ` "\neval:\n" `)) \_ ->
        bind r \u -> return case u of { Unit -> Unit}
in

let main =
    let bind = bind MonadIO in
    let return = return MonadIO in

    let readString =
        rec readString = \u -> bind readChar \c -> case c of {
            Nothing -> return Nil;
            Just c-> bind (readString u) \s ->
                        return (Cons c s)
        }
        in
        readString Unit
    in
    rec writeString = \s -> case s of {
        Cons h t -> bind (writeChar h) \u ->
                         writeString t;
        Nil -> return Unit
    }
    in

    bind readString \s ->
    bind (writeString (toString ffi ` "input:\n" `)) \_ ->
    bind (writeString s) \_ ->
         let tokens = case runParser lex s of {
            Left e -> case e of {
                ParsingError e -> Left e;
                GenericParsingError e -> Left e
            };
            Right r -> case r of { Pair r tokens -> Right tokens }
         }
         in
         let expr = case tokens of {
            Left e -> Left e;
            Right tokens -> case runParser parse tokens of {
                Left e -> case e of {
                    ParsingError e -> Left e;
                    GenericParsingError e -> Left e
                };
                Right r -> case r of {
                    Pair t expr -> Right expr
                }
            }
         }
         in
         let type = case expr of {
            Left e -> Left e;
            Right expr -> typeInfer expr
         }
         in
         let output = case tokens of {
            Left e -> e;
            Right tokens -> case expr of {
                Left e -> e;
                Right expr ->  case expr of {
                    Pair gadts expr -> case type of {
                        Left e -> e;
                        Right t -> listJoin (Cons (listJoin (map (\t ->listJoin (Cons (tokenToString t) (Cons (toString ffi ` " " `) Nil))) tokens))
                                            (Cons (gadtsToString gadts)
                                            (Cons (exprToString expr)
                                            (Cons (toString ffi ` " : " `)
                                            (Cons (monoToString t) Nil)))))
                    }
                }
            }
         }
         in
    bind (writeString (toString ffi ` "output:\n" `)) \_ ->
    bind (writeString output) \_ ->
    bind (writeString (toString ffi ` "\n" `)) \_ ->
         let eval = case type of {
            Left e -> return Unit;
            Right t -> case t of {
                MonoVar t -> writeString (toString ffi ` "output: expect IO Unit" `);
                MonoApp c ts -> case stringEq c (toString ffi ` "IO" `) of {
                    False -> writeString (toString ffi ` "output: expect IO Unit" `);
                    True -> case ts of {
                        Cons h t -> case t of {
                            Cons h t -> writeString (toString ffi ` "output: expect IO Unit" `);
                            Nil -> case h of {
                                MonoVar t -> writeString (toString ffi ` "output: expect IO Unit" `);
                                MonoApp c ts -> case stringEq c (toString ffi ` "Unit" `) of {
                                    False -> writeString (toString ffi ` "output: expect IO Unit" `);
                                    True -> case t of {
                                        Cons h t -> writeString (toString ffi ` "output: expect IO Unit" `);
                                        Nil -> case expr of {
                                            Left e -> writeString (toString ffi ` "output: unreachable" `);
                                            Right expr -> eval expr
                                        }
                                    }
                                }
                            }
                        };
                        Nil -> writeString (toString ffi ` "output: expect IO Unit" `)
                    }
                }
            }
         }
         in
         eval
in
runIO main
