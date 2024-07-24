with builtins; rec {
  opAdd = x: y: x + y;
  opCon = x: y: x ++ y;
  opTest = x: y: "(${x} + ${y})";
  
  foldl = f: i: xs: if length xs == 0
    then i
    else foldl f (f i (head xs)) (tail xs)
  ;
  foldr = f: i: xs: if length xs == 0
    then i
    else f i (foldr f (head xs) (tail xs))
  ;
  foldlSet = f: i: set: foldl f i (attrValues set);
  foldrSet = f: i: set: foldr f i (attrValues set);
}