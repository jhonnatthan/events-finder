{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Confirmacao where

import Import

postConfirmacaoR :: Key Evento -> Handler Html
postConfirmacaoR eventoid = do
    session <- lookupSession "_ID"
    case session of
        Nothing -> redirect EventoListR
        Just email -> do
            usuario <- runDB $ selectFirst [UsuarioEmail ==. email] []
            case usuario of
                Just (Entity usuario _) -> do 
                    pid <- runDB $ insert (Confirmacao "Confirmado" usuario eventoid)
                    redirect ConfirmacaoListR
                Nothing -> redirect HomeR