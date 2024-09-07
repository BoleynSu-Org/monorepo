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

data Eq a {
    MkEq:forall a.(a->a->Bool)->Eq a
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
data Parser t e a {
    Parser:forall t.forall e.forall a.(List t->Either e (Pair (List t) a))->Parser t e a
}

-- impl
data Token {
  HashBang:Token;

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
  Comment:List Char->Token;
  End:Token;

  Error:List Char->Token
}

data Position {
    Position:List Char->FfiInt->FfiInt->Position
}

-- ffi
let toChar:FfiInt -> Char = \c -> ffi ` ({
    char* c = BSL_RT_MALLOC(1);
    *c = (int)$c;
    c;
}) `
in
rec toString:FfiString -> List Char = \s -> ffi ` ({
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

let readChar:IO (Maybe Char) = IO \r -> Pair r ffi ` ({
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
let writeChar:Char->IO Unit = \c -> IO \r -> Pair r ffi ` ({
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
let charEq = \x -> \y -> ffi ` (*(char*)$x == *(char*)$y ? $True : $False) ` in

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
let parse = \p -> case p of { Parser parse -> parse } in
let MonadParser:forall t.forall e.Monad (Parser t e) =
    let fmap = \f -> \p -> Parser \t -> case parse p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            Right (Pair nt (f x))
        }
    }
    in
    let pure = \r->Parser \t -> Right (Pair t r) in
    let bind = \p -> \f -> Parser \t -> case parse p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            parse (f x) nt
        }
    }
    in
    let ap = \f -> \a -> bind f \f -> bind a \x -> pure (f x) in
    let mk = MkFunctor in
    let mk2 = MkMonad in
    let FunctorParser = MkFunctor fmap in
    let ApplicativeParser = MkApplicative FunctorParser pure ap in

    MkMonad ApplicativeParser bind
in
let AlternativeParser = case MonadParser of {
    MkMonad a b ->
        let empty = Parser \t -> Left  (toString ffi ` "error: empty: no matches" `) in
        let alt = \a -> \b -> Parser \t -> case parse a t of {
            Left err -> case parse b t of {
                Left err' -> Left err;
                Right r -> Right r
            };
            Right r -> Right r
        }
        in
        MkAlternative a empty alt
}
in

let matchChar:Char->Parser Char (List Char) Char = \c -> Parser \s -> case s of {
    Cons h t -> case charEq c h of {
        True -> Right (Pair t h);
        False -> Left (toString ffi ` "error: matchChar: char does not match" `)
    };
    Nil -> Left (toString ffi ` "error: matchChar: no char to match" `)
}
in

-- impl
let lex =
    let bind = bind MonadParser in
    let return = return MonadParser in
    let alt = case AlternativeParser of { MkAlternative a e alt -> alt } in
    rec some = \x -> Parser \t -> case parse x t of {
        Left e -> Right (Pair t Nil);
        Right r -> case r of { Pair nt h ->
            case parse (some x) nt of {
                Left e -> Left e;
                Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
            }
        }
    }
    in
    rec all = \x -> Parser \ts -> case ts of {
        Nil -> Right (Pair Nil Nil);
        Cons h t -> case parse x ts of {
            Left e -> Left e;
            Right r -> case r of { Pair nt h ->
                case parse (all x) nt of {
                    Left e -> Left e;
                    Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
                }
            }
        }
    }
    in
    let some1 = \x -> bind x \h -> bind (some x) \t -> return (Cons h t) in
    let arrow = bind (matchChar (toChar ffi ` '-' `)) \c ->
                bind (matchChar (toChar ffi ` '>' `)) \c ->
                     return Arrow
    in
    let lambda = bind (matchChar (toChar ffi ` '\\' `)) \c ->
                      return Lambda
    in
    let let_ = bind (matchChar (toChar ffi ` 'l' `)) \c ->
               bind (matchChar (toChar ffi ` 'e' `)) \c ->
               bind (matchChar (toChar ffi ` 't' `)) \c ->
                    return Let
    in
    let equal = bind (matchChar (toChar ffi ` '=' `)) \c ->
                     return Equal
    in
    let in_ = bind (matchChar (toChar ffi ` 'i' `)) \c ->
              bind (matchChar (toChar ffi ` 'n' `)) \c ->
                   return In
    in
    let identifier = bind (some1 (matchChar (toChar ffi ` 'x' `))) \s ->
                          return (Identifier s)
    in
    let whitespace = bind (some1 (alt (matchChar (toChar ffi ` ' ' `)) (matchChar (toChar ffi ` '\n' `)))) \s ->
                          return (Whitespace s)
    in

    all (alt arrow (alt lambda (alt let_ (alt equal (alt in_ (alt identifier whitespace))))))
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
         let err = case parse lex s of {
            Left e -> e;
            Right r -> toString ffi ` "no error" `
         }
         in
    bind (writeString err) \u ->
    bind (writeString (toString ffi ` "\ninput:\n" `)) \u ->
    bind (writeString s) \u ->
         return u
in
runIO main
