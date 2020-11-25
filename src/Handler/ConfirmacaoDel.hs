{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.ConfirmacaoDel where

import Import

postConfirmacaoDelR :: Key Confirmacao -> Handler Html
postConfirmacaoDelR confirmacaoid = do
    runDB $ delete confirmacaoid
    redirect EventoListR
                