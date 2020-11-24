{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Usuario where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)

data RegularUser = RegularUser {
        regularUsuarioNome        :: Text
    ,   regularUsuarioEmail       :: Text
    ,   regularUsuarioSenha    :: Text
}

formUsuarioLoginForm :: Form (RegularUser, Text)
formUsuarioLoginForm = renderBootstrap3 BootstrapBasicForm $ (,)
    <$> (RegularUser 
        <$> areq textField (FieldSettings "Nome" Nothing Nothing Nothing [("class", "form-control")]) Nothing
        <*> areq textField (FieldSettings "Email" Nothing Nothing Nothing [("class", "form-control")]) Nothing
        <*> areq passwordField (FieldSettings "Senha" Nothing Nothing Nothing [("class", "form-control")]) Nothing
    )
    <*> areq passwordField (FieldSettings "Confirmação de senha" Nothing Nothing Nothing [("class", "form-control")]) Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (formWidget, _) <- generateFormPost formUsuarioLoginForm
    msg <- getMessage
    session <- lookupSession "_ID"
    defaultLayout $ do
        case session of
            Just _ -> redirect HomeR
            Nothing -> do
                setTitle "Events Finder - Entrar"
                $(widgetFile "pages/usuario")

postUsuarioR :: Handler Html
postUsuarioR = do
    ((result, _), _) <- runFormPost formUsuarioLoginForm
    case result of
        FormSuccess (user, password_confirm) -> do
            user' <- runDB $ getBy (UniqueEmail $ regularUsuarioEmail user)
            case user' of
                Just _ -> do
                        setMessage [shamlet|
                            <div .alert .alert-warning role=alert>
                                <p><strong>Oops!</strong> E-mail fornecido já cadastrado na aplicação
                        |] 
                        redirect UsuarioR
                Nothing -> do
                    if (password_confirm == regularUsuarioSenha user) then do
                        _ <- runDB $ insert400 (Usuario (regularUsuarioNome user) (regularUsuarioEmail user) (regularUsuarioSenha user) False )
                        
                        setSession "_ID" (regularUsuarioEmail user)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            <div .alert .alert-warning role=alert>
                                <p><strong>Atenção!</strong> Senhas não coincidem
                        |]
                        redirect UsuarioR
                    
            -- _ <- runDB $ insert user
        _ -> redirect HomeR