{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Confirmacao where

import Import

getConfirmacaoR :: Handler Html
getConfirmacaoR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")


postConfirmacaoR :: Handler Html
postConfirmacaoR = 
    defaultLayout $ do
        setTitle "Events Finder - Home"
        $(widgetFile "pages/home")
