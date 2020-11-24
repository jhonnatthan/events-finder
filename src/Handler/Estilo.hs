{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Estilo where

import Import

getEstiloR :: Handler Html
getEstiloR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")


postEstiloR :: Handler Html
postEstiloR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")
