{-# LANGUAGE Safe #-}
module Gitstar where

import Data.ByteString.Char8
import Data.Monoid
import Hails.App
import Controllers
import Data.IterIO.Http.Support.Action

toRestShow :: RestController m a => a -> Action t m ()
toRestShow ctr = do
  (Just var) <- param $ pack "id"
  restShow ctr $ paramValue var

server :: AppReqHandler
server = runLHttpRoute $ mconcat 
    [ routeName "static" $ routeFileSys systemMimeMap (dirRedir "index.html") "static"
    , routeRestController "projects" ProjectsController
    , routeRestController "keys" KeysController
    , routeActionPattern "/:user_name/keys" $ listKeys
    , routeActionPattern "/:user_name/:id" $ toRestShow ProjectsController
    , routeActionPattern "/:user_name" $ userShow
    ]
