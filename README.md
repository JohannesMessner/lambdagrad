# lambdagrad
Automatic gradients in ~70 lines of Haskell

Load the `Engine` module:
```terminal
$ ghci
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
Prelude> :l Engine
[1 of 2] Compiling Data             ( Data.hs, interpreted )
[2 of 2] Compiling Engine           ( Engine.hs, interpreted )
Ok, two modules loaded.
```

Use `val` to creat computational graphs:

```bash
*Engine> expression = ((val 0.5) + (val 3)) ** 2
*Engine> expression
InnerNode Pow 12.25 0.0 (InnerNode Plus 3.5 0.0 (Leaf 0.5 0.0) (Leaf 3.0 0.0)) (Leaf 2.0 0.0)
```

Use `backward` to compute gradients:

```bash
*Engine> backward expression
InnerNode Pow 12.25 1.0 (InnerNode Plus 3.5 7.0 (Leaf 0.5 7.0) (Leaf 3.0 7.0)) (Leaf 2.0 0.0)
```

Use `getLeafs` to get leaf node of the computational graph:
```bash
*Engine> getLeafs $ backward expression
[Leaf 0.5 7.0,Leaf 3.0 7.0,Leaf 2.0 0.0]
```

And `gradient` to extract their gradients:
```bash
*Engine> map gradient (getLeafs $ backward expression)
[7.0,7.0,0.0]
```
