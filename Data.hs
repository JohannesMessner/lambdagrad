module Data where

data Op = Plus | Times | Pow deriving (Ord, Eq, Show)
type Value = Float
type Gradient = Float
data Node = Leaf Value Gradient | InnerNode Op Value Gradient Node Node deriving (Ord, Eq, Show)


val :: Float -> Node
val v = Leaf v 0


value :: Node -> Value
value (Leaf v _) = v
value (InnerNode _ v _ _ _) = v

instance Num Node where
    n1 + n2 = InnerNode Plus (value n1 + value n2) 0 n1 n2
    n1 * n2 = InnerNode Times (value n1 * value n2) 0 n1 n2
    n1 - n2 = InnerNode Plus (value n1 - value n2) 0 n1 n2
    abs n@(Leaf v g) = Leaf (abs v) g
    abs n@(InnerNode op v g n1 n2) = InnerNode op (abs v) g n1 n2
    signum n@(Leaf v g) = Leaf (signum v) g
    signum n@(InnerNode op v g n1 n2) = InnerNode op (signum v) g n1 n2
    fromInteger i = Leaf (fromIntegral i) 0

instance Fractional Node where
    n1 / n2 = n1 * (n2 ** (val $ -1))
    fromRational r = Leaf (fromRational r) 0

instance Floating Node where
    pi = Leaf pi 0
    n1 ** n2 = InnerNode Pow (value n1 ** value n2) 0 n1 n2
    exp n = (val $ exp 1) ** n
    -- not supported for now
    log = id
    sin = id
    cos = id
    sinh = id
    cosh = id
    asinh = id
    acosh = id
    atanh = id
    asin = id
    acos = id
    atan = id
