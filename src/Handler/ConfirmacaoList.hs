{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}

module Handler.ConfirmacaoList where

import Import

getConfirmacaoListR :: Handler Html
getConfirmacaoListR = do 
    session <- lookupSession "_ID"
    case session of
        Just email -> do
            usuario <- runDB $ selectFirst [UsuarioEmail ==. email] []
            case usuario of
                Just (Entity usuarioid _) -> do 
                    confirmacoes <- runDB $ selectList [ConfirmacaoTipo ==. "Confirmado", ConfirmacaoUsuarioId ==. usuarioid] []
                    defaultLayout $ do
                        setTitle "Events Finder - Confirmados"
                        $(widgetFile "pages/confirmacao/list")
                Nothing -> redirect LoginR
        Nothing -> redirect LoginR   

showEventoEstilo :: Evento -> Widget
showEventoEstilo evento = do
    estilo <- handlerToWidget $ runDB $ get404 $ eventoEstiloId evento
    [whamlet|
        <td>#{estiloNome estilo}
    |]

showConfirmacaoEvento :: Confirmacao -> Widget
showConfirmacaoEvento confirmacao = do
    evento <- handlerToWidget $ runDB $ get404 $ confirmacaoEventoId confirmacao
    [whamlet|
        <td>#{eventoTitulo evento}
        <td>#{eventoLocalizacao evento}
        ^{showEventoEstilo evento}
    |]