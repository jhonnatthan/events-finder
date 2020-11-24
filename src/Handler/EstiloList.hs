{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.EstiloList where

import Import

getEstiloListR :: Handler Html
getEstiloListR = do    
    estilos <- runDB $ selectList [] [Asc EstiloNome]
    muser <- lookupSession "_ID"
    case muser of
        Nothing -> redirect HomeR
        Just email -> do
            user <- runDB $ selectFirst [UsuarioEmail ==. email] []
            case user of
                Nothing -> redirect HomeR
                Just (Entity _ ( Usuario _ _ _ isAdmin' )) -> 
                    defaultLayout $ do
                        setTitle "Events Finder - Estilos"
                        $(widgetFile "pages/estilo/list")

