--
-- Configuration file for XMonad + MATE
--
--  Usage:
--      * Copy this file to ~/.xmonad/
--      * Run:    $ xmonad --recompile
--      * Launch: $ xmonad --replace
--      [Optional] Create an autostart to command with "xmonad --replace"
--
--  Author: Arturo Fernandez <arturo at bsnux dot com>
--  Inspired by:
--      Spencer Janssen <spencerjanssen@gmail.com>
--      rfc <reuben.fletchercostin@gmail.com>
--  License: BSD
--
import XMonad
import XMonad.Config.Desktop
import XMonad.Util.Run (safeSpawn)
import qualified Data.Map as M
import System.Environment (getEnvironment)
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Hooks.EwmhDesktops

gnomeConfig = desktopConfig
    { terminal        = "gnome-terminal"
    , keys            = gnomeKeys <+> keys desktopConfig
    , startupHook     = setWMName "LG3D"
    }

gnomeKeys (XConfig {modMask = modm}) = M.fromList $
    [ ((modm, xK_p), gnomeRun)
    , ((modm .|. shiftMask, xK_q), spawn "gnome-session-save --kill") ]

gnomeRun :: X ()
gnomeRun = withDisplay $ \dpy -> do
    rw <- asks theRoot
    gnome_panel <- getAtom "_GNOME_PANEL_ACTION"
    panel_run   <- getAtom "_GNOME_PANEL_ACTION_RUN_DIALOG"

    io $ allocaXEvent $ \e -> do
        setEventType e clientMessage
        setClientMessageEvent e rw gnome_panel 32 panel_run 0
        sendEvent dpy rw False structureNotifyMask e
        sync dpy False

main = xmonad $ ewmhFullscreen . ewmh 
              $ fullscreenSupportBorder
              $ gnomeConfig
                   { modMask = mod4Mask
                   , borderWidth = 4
                   , focusedBorderColor = "#800080" -- "#7FBC71"
                   } `additionalKeysP` myKeys

myKeys = [  (("M4-f"), spawn "brave-browser")
           ,(("M4-a"), spawn "/home/haemin/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh")
           ,(("M4-="), spawn "uim-toolbar-gtk3-systray")
           ,(("M4-z"), kill)
         ]
