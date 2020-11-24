{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.EventoList where

import Import


getEventoListR :: Handler Html
getEventoListR = do    
    eventos <- runDB $ selectList [] [Asc EventoTitulo]
    muser <- lookupSession "_ID"
    case muser of
        Nothing -> redirect HomeR
        Just email -> do
            user <- runDB $ selectFirst [UsuarioEmail ==. email] []
            case user of
                Nothing -> redirect HomeR
                Just (Entity _ ( Usuario _ _ _ isAdmin' )) -> 
                    defaultLayout $ do
                        setTitle "Events Finder - Eventos"
                        $(widgetFile "pages/evento/list")