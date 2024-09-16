#!/bin/bash
set -euo pipefail

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
source "$0.runfiles/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
{ echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

$(rlocation boleynsu_org/legacy/BSL-AlgorithmW/example/bootstrap) <<'EOF'
data Char {}
data Unit {}
data Piar a b {
    Pair:forall a.forall b.a->b->Pair a b
}
data RealWorld {
    RealWorld:RealWorld
}
data IO a {
    IO:forall a.RealWorld->Pair RealWorld a
}
data List a {
    Cons:forall a.a->List a->List a;
    Nil:forall a.List a
}
let t = \x -> \y -> x in
let w = \x -> x in
let f = \x -> \y -> y in
let a = t w in
let b = t f in
let x = b f t str in
let w = writeString in
let x = \y -> str in
let x = x t in
let main = w x in
--let l = Cons Unit Nil in
let head = \l -> case l of {Cons h t -> h } in
let ifthenelse = \x -> \y -> \z -> x y z in -- if then else
rec fix = \f -> f (g f) and g = \x -> fix x in
let t = \x -> \y -> x in
rec tt = ifthenelse (\x -> \y -> x ) in
let id = \x->x in
rec id = \x -> (ifthenelse t (\y -> x) (\y -> id x)) x and id2 = id in
rec test = ifthenelse t (id main){- comment -}((\x->\y->x) ) in
let test = ifthenelse t (id main){- comment -}((\x->\y->x) ) in
let id = \x->x in
ifthenelse t (id2 (id main)){- comment -} (id2 (\x->\y->x) )
EOF
