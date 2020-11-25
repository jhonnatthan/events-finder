{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}

module Handler.EventoList where

import Import

getEventoListR :: Handler Html
getEventoListR = do    
    session <- lookupSession "_ID"
    case session of
        Just email -> do
            usuario <- runDB $ selectFirst [UsuarioEmail ==. email] []
            case usuario of
                Just (Entity usuarioid _) -> do 
                    eventos <- runDB $ selectList [] [Asc EventoTitulo]
                    defaultLayout $ do
                        setTitle "Events Finder - Eventos"
                        $(widgetFile "pages/evento/list")
                Nothing -> redirect LoginR
        Nothing -> redirect LoginR

showEventoEstilo :: Evento -> Key Evento -> Key Usuario -> Widget
showEventoEstilo evento eventoid usuarioid = do
    estilo <- handlerToWidget $ runDB $ get404 $ eventoEstiloId evento
    [whamlet|
        <td>#{estiloNome estilo}
        ^{showEventoConfirmacao eventoid usuarioid}
    |]

showEventoConfirmacao :: Key Evento -> Key Usuario -> Widget
showEventoConfirmacao eventoid usuarioid = do
    confirmacao <- handlerToWidget $ runDB $ selectFirst [ConfirmacaoUsuarioId ==. usuarioid, ConfirmacaoEventoId ==. eventoid] []
    case confirmacao of
        Just (Entity confirmacaoid confirmacao') -> do
            [whamlet|
                <td>#{confirmacaoTipo confirmacao'}
                <td>
                    <form action=@{ConfirmacaoDelR confirmacaoid} method="post">
                        <input .btn.btn-primary type="submit" value="Remover">
            |]
        Nothing -> do
            [whamlet|
                <td>Não confirmado
                <td>
                    <form action=@{ConfirmacaoR eventoid} method="post">
                        <input .btn.btn-primary type="submit" value="Confirmar">
            |]
        
                
        

    

    