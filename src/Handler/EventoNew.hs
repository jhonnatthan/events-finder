{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.EventoNew where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

formEvento :: [(Text, Key Estilo)] -> Form Evento
formEvento estilos = renderBootstrap3 BootstrapBasicForm $ Evento
    <$> areq textField (FieldSettings "Titulo" Nothing Nothing Nothing [("class", "form-control")]) Nothing
    <*> areq textField (FieldSettings "Localização" Nothing Nothing Nothing [("class", "form-control")]) Nothing
    <*> areq dayField (FieldSettings "Data do evento" Nothing Nothing Nothing [("class", "form-control")]) Nothing
    <*> areq (selectFieldList estilos) (FieldSettings "Estilo do Evento" Nothing Nothing Nothing [("class", "form-control")]) Nothing


mapEstilos :: [Entity Estilo] -> [(Text, Key Estilo)]
mapEstilos [] = []
mapEstilos xs = map (\(Entity eid (Estilo nome)) -> (nome, eid)) xs


getEventoNewR :: Handler Html
getEventoNewR = do
    
    estilos <- runDB $ selectList [] [Desc EstiloId]

    (formWidget, _) <- generateFormPost $ formEvento $ mapEstilos estilos
    
    defaultLayout $ do
        msg <- getMessage
        session <- lookupSession "_ID"

        case session of
            Just _ -> do
                setTitle "Events Finder - Novo Evento"
                $(widgetFile "pages/evento/new")
            Nothing -> redirect HomeR

postEventoNewR :: Handler Html
postEventoNewR = do
    estilos <- runDB $ selectList [] [Desc EstiloId]
    
    ((result, _), _) <- runFormPost $ formEvento $ mapEstilos estilos

    case result of
        FormSuccess evento -> do
            runDB $ insert400 evento
            redirect EventoListR
        _ -> redirect HomeR

