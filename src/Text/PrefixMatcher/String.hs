module Text.PrefixMatcher.String where
import Data.List

-- A simple non-generic prefix matching library
-- with a few simple combinators
--
-- a Matcher has type (String -> Maybe Int)
--
-- It takes a String and returns a number corresponding
-- to the length of the matched prefix.
--
-- The intended use case here is to provide a simple utility
-- to help in converting a string to a stream of tokens.
--
-- makeMatcher -- make a matcher for a constant string
-- 

type Matcher = String -> Maybe Int


identityMatcher :: Matcher
identityMatcher str = Just 0


makeMatcher :: String -> Matcher
makeMatcher spec str = case isPrefixOf spec str of
    True -> Just (length spec)
    False -> Nothing


andThen :: Matcher -> Matcher -> Matcher
andThen m1 m2 str = ltotal where
    l1 = m1 str
    ltotal = case l1 of
        Nothing -> Nothing
        (Just l1) ->
            let rest = drop l1 str in
            let l2 = m2 str in
            case l2 of
                Nothing -> Nothing
                (Just l2) -> Just (l1 + l2)


symOrExn :: Matcher -> Matcher -> Matcher
symOrExn m1 m2 str = res where
    l1 = m1 str
    l2 = m2 str
    res = case (l1, l2) of
        -- good cases
        (Just l1, Nothing) -> Just l1
        (Nothing, Just l2) -> Just l2
        -- bad cases
        (Nothing, Nothing) -> Nothing
        -- if you reach this case, the grammar was
        -- constructed badly
        (Just l1, Just l2) -> error "ambiguous match"


leftOr :: Matcher -> Matcher -> Matcher
leftOr m1 m2 str = result where
    l1 = m1 str
    l2 = m2 str

    result = case (l1, l2) of
        (Just l1, _) -> Just l1
        (Nothing, Just l2) -> Just l2
        (Nothing, Nothing) -> Nothing


andThenList :: [Matcher] -> Matcher
andThenList [] = identityMatcher
andThenList [x] = x
andThenList (x:xs) = andThen x (andThenList xs)


leftOrList :: [Matcher] -> Matcher
leftOrList [] = identityMatcher
leftOrList [x] = x
leftOrList (x:xs) = leftOr x (leftOrList xs)
