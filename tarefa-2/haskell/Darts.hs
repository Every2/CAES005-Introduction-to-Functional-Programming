score :: Float -> Float -> Int
score x y
    | num > 10 = 0
    | num > 5 = 1
    | num > 1 = 5
    | otherwise = 10
      where
        num = sqrt (x * x + y * y)
        -- Apply this every time that conditions meet the requierements 
