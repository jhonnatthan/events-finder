{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Evento where

import Import

getEventoR :: Handler Html
getEventoR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")


postEventoR :: Handler Html
postEventoR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")
