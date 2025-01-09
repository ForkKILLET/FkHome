with builtins; rec {
  opAdd = x: y: x + y;
  opCon = x: y: x ++ y;
  
  foldl = foldl';
  foldr = f: i: xs: if length xs == 0
    then i
    else f i (foldr f (head xs) (tail xs))
  ;
  foldlSet = f: i: set: foldl f i (attrValues set);
  foldrSet = f: i: set: foldr f i (attrValues set);
}