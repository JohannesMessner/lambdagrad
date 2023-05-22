module Engine where

import HuskyData


backward :: Node -> Node  -- calculates the gradient of each node in the graph
backward (Leaf v g) = Leaf v 1
backward (InnerNode op v g c1 c2) = backward_ $ InnerNode op v 1 c1 c2


backward_ :: Node -> Node
backward_ parent@(InnerNode Pow v g base expo) = InnerNode Pow v g (backward_$ updateGradient base expo parent) (Leaf (value expo) 0) -- gradients do not flow to the exponent for now
backward_ parent@(InnerNode op v g c1 c2) = InnerNode op v g (backward_$ updateGradient c1 c2 parent) (backward_$ updateGradient c2 c1 parent)
backward_ (Leaf v g) = Leaf v g


updateGradient :: Node -> Node -> Node -> Node
updateGradient n@(InnerNode op v g c1 c2) sibling parent = InnerNode op v (computeGradient n sibling parent) c1 c2
updateGradient n@(Leaf v g) sibling parent = Leaf v (computeGradient n sibling parent)


computeGradient :: Node -> Node -> Node -> Gradient
computeGradient n sibling parent@(InnerNode Plus _ g_parent _ _ ) = gradient n + g_parent
computeGradient n sibling parent@(InnerNode Times _ g_parent _ _ ) = gradient n + (g_parent * value sibling)
computeGradient n sibling parent@(InnerNode Pow _ g_parent _ _ ) = gradient n + (g_parent * (value sibling * value n ** (value sibling - 1)))  -- gradients do not flow to the exponent for now
computeGradient n _ (Leaf _ _ ) = gradient n


gradient :: Node -> Gradient
gradient (Leaf _ g) = g
gradient (InnerNode _ _ g _ _) = g


getLeafs :: Node -> [Node]
getLeafs (Leaf v g) = [Leaf v g]
getLeafs (InnerNode _ _ _ c1 c2) = getLeafs c1 ++ getLeafs c2
