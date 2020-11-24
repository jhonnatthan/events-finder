{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.EstiloNew where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

formEstilo :: Form Estilo
formEstilo = renderBootstrap3 BootstrapBasicForm $ Estilo
    <$> areq textField (FieldSettings "Nome do estilo" Nothing Nothing Nothing [("class", "form-control")]) Nothing
    

getEstiloNewR :: Handler Html
getEstiloNewR = do    
    
    (formWidget, _) <- generateFormPost formEstilo

    defaultLayout $ do
        msg <- getMessage
        session <- lookupSession "_ID"

        case session of
            Just _ -> do
                setTitle "Events Finder - Cadastrar estilo"
                $(widgetFile "pages/estilo/new")
            Nothing -> redirect HomeR


postEstiloNewR :: Handler Html
postEstiloNewR = do
    ((result, _), _) <- runFormPost formEstilo
    case result of
         FormSuccess estilo -> do
            _ <- runDB $ insert estilo
            redirect EstiloListR
         _ -> redirect HomeR
