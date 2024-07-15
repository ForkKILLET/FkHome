with builtins; rec {
  foldlSet = op: init: set:
    foldl
      (a: c: op { name = name1; value = getAttr name1 set } { name = name2; value = getAttr name2 set })
      init
      (attrNames set)
}
