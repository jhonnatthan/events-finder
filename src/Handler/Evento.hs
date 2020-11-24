{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Evento where

import Import

getEventoR :: Key Evento -> Handler Html
getEventoR eventoid = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/mock")


postEventoR :: Key Evento -> Handler Html
postEventoR eventoid = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/mock")

deleteEventoR :: Key Evento -> Handler Html
deleteEventoR eventoid = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/mock")
