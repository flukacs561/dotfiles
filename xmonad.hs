import Data.Map qualified as M
import Data.Monoid (All)
import Data.Ratio ((%))
import XMonad
import XMonad.Actions.SpawnOn (spawnOn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks
  ( ToggleStruts (ToggleStruts),
    avoidStruts,
    docks,
    manageDocks,
  )
import XMonad.Hooks.ManageHelpers (doRaise, doRectFloat)
import XMonad.Layout.BoringWindows
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.Simplest (Simplest (Simplest))
import XMonad.Layout.SubLayouts
  ( GroupMsg (MergeAll, UnMerge, UnMergeAll),
    onGroup,
    pullGroup,
    subLayout,
  )
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation (windowNavigation)
import XMonad.Prompt qualified as P
import XMonad.Prompt.AppLauncher (launchApp)
import XMonad.Prompt.FuzzyMatch (fuzzyMatch, fuzzySort)
import XMonad.Prompt.Pass
  ( passEditPrompt,
    passGeneratePrompt,
    passPrompt,
    passRemovePrompt,
    passTypePrompt,
  )
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.Window
  ( WindowPrompt (Goto),
    allWindows,
    windowPrompt,
  )
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig (mkKeymap)
import XMonad.Util.Run (hPutStrLn, spawnPipe)

-- brightGreen = #009933
darkGrey = "#282828"

darkRed = "#cc241d"

darkYellow = "#98971a"

darkOrange = "#d79921"

darkBlue = "#458588"

darkPurple = "#b16286"

darkGreen = "#228062"

darkBeige = "#a89984"

lightGrey = "#928374"

lightRed = "#fb4934"

lightYellow = "#b8bb26"

lightOrange = "#fabd2f"

lightBlue = "#83a598"

lightPurple = "#d3869b"

lightGreen = "#8ec07c"

lightBeige = "#ebdbb2"

myEmacs :: String
myEmacs = "emacsclient -c -a \"emacs\""

-- Preferred terminal program
myTerminal :: String
myTerminal = "alacritty"

myScreenLocker :: String
myScreenLocker = "XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_PASSWORD_PROMPT=\"asterisks\" xsecurelock"

myBrowser :: String
myBrowser = "chromium"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth = 4

-- Set mod key to the win (super) key
myModMask :: KeyMask
myModMask = mod4Mask

altMask :: KeyMask
altMask = mod1Mask

-- Names of my workspaces
myWorkspaces :: [String]
myWorkspaces = ["term", "web", "maths", "book", "misc", "mail"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor :: String
myNormalBorderColor = darkGrey

myFocusedBorderColor :: String
myFocusedBorderColor = darkGreen

-- Set my font
myFont :: String
myFont = "Iosevka Comfy"

-- Helper function to set up fonts
setMyFont :: String -> Int -> String
setMyFont font size = "xft:" ++ font ++ ":bold:size=" ++ show size ++ ":antialias=true:hinting=true"

-- Get the number of windows open on the current workspace
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Configuration for prompts
myXPConfig :: P.XPConfig
myXPConfig =
  def
    { P.font = setMyFont myFont 12,
      P.bgColor = lightBeige,
      P.fgColor = darkGrey,
      P.bgHLight = lightGreen,
      P.fgHLight = darkGrey,
      P.borderColor = darkGreen,
      P.promptBorderWidth = 2,
      P.promptKeymap = myXPKeymap,
      P.position = P.CenteredAt {P.xpCenterY = 0.3, P.xpWidth = 0.3},
      P.height = 30,
      P.historySize = 256,
      P.historyFilter = id,
      P.defaultText = [],
      P.autoComplete = Nothing,
      P.complCaseSensitivity = P.CaseInSensitive,
      P.showCompletionOnTab = False,
      P.searchPredicate = fuzzyMatch,
      P.sorter = fuzzySort,
      P.alwaysHighlight = True,
      P.maxComplRows = Just 8 -- set to Nothing for no limit on rows
    }

myXPConfigAutoComplete :: P.XPConfig
myXPConfigAutoComplete =
  myXPConfig
    { P.autoComplete = Just 10000 -- That is .1 second
    }

myXPConfigMpv :: P.XPConfig
myXPConfigMpv =
  myXPConfig
    { P.defaultText = "/home/lukacsf/let/"
    }

myXPKeymap :: M.Map (KeyMask, KeySym) (P.XP ())
myXPKeymap =
  M.fromList $
    fmap
      (helper controlMask) -- control + <key>
      [ (xK_z, P.killBefore), -- kill line backwards
        (xK_k, P.killAfter), -- kill line forwards
        (xK_a, P.startOfLine), -- move to the beginning of the line
        (xK_e, P.endOfLine), -- move to the end of the line
        (xK_d, P.deleteString P.Next), -- delete a character foward
        (xK_b, P.moveCursor P.Prev), -- move cursor forward
        (xK_f, P.moveCursor P.Next), -- move cursor backward
        (xK_BackSpace, P.killWord P.Prev), -- kill the previous word
        (xK_y, P.pasteString), -- paste a string
        (xK_g, P.quit) -- quit out of prompt
      ]
      ++ fmap
        (helper altMask) -- meta key + <key>
        [ (xK_BackSpace, P.killWord P.Prev), -- kill the prev word
          (xK_f, P.moveWord P.Next), -- move a word forward
          (xK_b, P.moveWord P.Prev), -- move a word backward
          (xK_d, P.killWord P.Next), -- kill the next word
          (xK_n, P.moveHistory W.focusUp'), -- move up through history
          (xK_p, P.moveHistory W.focusDown') -- move down through history
        ]
      ++ fmap
        (helper 0)
        [ (xK_Return, P.setSuccess True >> P.setDone True), -- select focused option
          (xK_KP_Enter, P.setSuccess True >> P.setDone True), -- select focused option
          (xK_BackSpace, P.deleteString P.Prev), -- delete a character backwards
          (xK_Delete, P.deleteString P.Next), -- delete a character forwards
          (xK_Left, P.moveCursor P.Prev), -- move cursor backwards
          (xK_Right, P.moveCursor P.Next), -- move cursor forwards
          (xK_Home, P.startOfLine), -- move to the start of the line
          (xK_End, P.endOfLine), -- move to the end of the line
          (xK_Down, P.moveHistory W.focusUp'), -- move up through history
          (xK_Up, P.moveHistory W.focusDown'), -- move down through history
          (xK_Escape, P.quit) -- quit out of prompt
        ]
  where
    helper modifier (key, action) = ((modifier, key), action)

myTabTheme :: Theme
myTabTheme =
  def
    { fontName = setMyFont myFont 9,
      decoHeight = 16,
      activeColor = darkGreen,
      inactiveColor = darkBeige,
      activeBorderColor = darkGreen,
      inactiveBorderColor = darkGrey,
      activeTextColor = lightBeige,
      inactiveTextColor = darkGrey
    }

------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here. --
------------------------------------------------------------
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys c =
  mkKeymap c $
    [ ("M-<Tab>", spawn myTerminal),
      ("M-C-l", spawn myScreenLocker),
      ("M-q", kill),
      ("M-<Space>", XMonad.Layout.BoringWindows.focusDown),
      ("M-S-<Space>", XMonad.Layout.BoringWindows.focusUp),
      ("M-<Print>", spawn "/home/lukacsf/code/system/./screenshot.sh"),
      ("M-b", spawn myBrowser),
      -- Window management commands
      ("M-h", sendMessage Shrink),
      ("M-l", sendMessage Expand),
      ("M-S-j", windows W.swapDown),
      ("M-S-k", windows W.swapUp),
      ("M-n", refresh),
      ("M-m", windows W.focusMaster),
      ("M-<Return>", windows W.swapMaster),
      ("M-C-t", withFocused $ windows . W.sink),
      ("M-f f", sendMessage NextLayout),
      ("M-f t", sendMessage ToggleStruts),
      ("M-s", sendMessage ToggleStruts),
      -- Tabbed sublayout commands
      ("M-t h", sendMessage $ pullGroup L),
      ("M-t l", sendMessage $ pullGroup R),
      ("M-t k", sendMessage $ pullGroup U),
      ("M-t j", sendMessage $ pullGroup D),
      ("M-t a", withFocused $ sendMessage . MergeAll),
      ("M-t u", withFocused $ sendMessage . UnMerge),
      ("M-t S-u", withFocused $ sendMessage . UnMergeAll),
      ("M-j", onGroup W.focusUp'),
      ("M-k", onGroup W.focusDown'),
      -- Keybindings for prompts
      -- The prefix for launching prompts is "M-r" for run
      ("M-r d", launchApp myXPConfig "zathura"),
      ("M-r v", launchApp myXPConfigMpv "mpv"),
      ("M-r r", runOrRaisePrompt myXPConfigAutoComplete),
      ("M-w", windowPrompt myXPConfigAutoComplete Goto allWindows),
      -- The submapping prefix for pass related prompts is p for pass
      ("M-r p p", passTypePrompt myXPConfig),
      ("M-r p c", passPrompt myXPConfig),
      ("M-r p g", passGeneratePrompt myXPConfig),
      ("M-r p e", passEditPrompt myXPConfig),
      ("M-r p r", passRemovePrompt myXPConfig),
      -- Keybindings for media related actions
      ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+ unmute"), -- raise volume
      ("S-<XF86AudioRaiseVolume>", spawn "amixer -q set Master 10%+ unmute"), -- raise volume
      ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%- unmute"), -- lower volume
      ("S-<XF86AudioLowerVolume>", spawn "amixer -q set Master 10%- unmute"), -- lower volume
      ("<XF86AudioMute>", spawn "amixer -q set Master toggle"), -- mute sound
      -- The prefix for issuing media commnds is "M-p" for playback
      ("M-p p", spawn "emacsclient -e \"(emms-pause)\""), -- play/pause music
      ("M-p b", spawn "emacsclient -e \"(emms-previous)\""), -- previous track
      ("M-p f", spawn "emacsclient -e \"(emms-next)\""), -- next track
      ("M-p s", spawn "emacsclient -e \"(emms-stop)\""), -- stop playback
      ("M-p c", spawn "pavucontrol")
    ]
      ++
      -- Keybindings for switching workspaces
      [ ("M-" ++ key, windows $ W.greedyView workspace)
        | (key, workspace) <- zip (fmap show [0 ..]) myWorkspaces
      ]
      ++
      -- Keybindings for moving windows between workspaces
      [ ("M-S-" ++ key, windows $ W.shift workspace)
        | (key, workspace) <- zip (fmap show [0 ..]) myWorkspaces
      ]

-----------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events --
-----------------------------------------------------------
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ( (modm, button2),
        \w -> focus w >> windows W.shiftMaster
      ),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
-- Mirror tiled for a vertical version of tiled
--

-- myLayout =
--     windowNavigation
--   $ addTabs shrinkText myTabTheme
--   $ subLayout [] Simplest
--   $ boringWindows
--   $ smartBorders
--   $ avoidStruts (tall ||| full)
--   where
--     -- default tiling algorithm partitions the screen into two panes
--     tall  = renamed [CutWordsRight 2] $ Tall nmaster delta ratio
--     -- The default number of windows in the master pane
--     nmaster = 1
--     -- Default proportion of screen occupied by master pane
--     ratio = 1 / 2
--     -- Percent of screen to increment by when resizing panes
--     delta = 3 / 100
--     -- standard monocle layout
--     full = renamed [CutWordsRight 2] Full

tall =
  renamed [XMonad.Layout.Renamed.Replace "tall"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] Simplest $
            boringWindows $
              avoidStruts $
                Tall nmaster delta ratio
  where
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

full =
  renamed [XMonad.Layout.Renamed.Replace "full"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] Simplest $
            boringWindows $
              avoidStruts Full

myLayout = tall ||| full

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
-- The WM_CLASS of pinentry is "pinentry" "Pinentry"
--

doFloatCenter :: ManageHook
doFloatCenter = doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ title =? "Save File" --> doFloatCenter,
      title =? "Bluetooth Devices" --> doFloatCenter,
      className =? "Pavucontrol" --> doFloatCenter,
      className =? "Brave-browser" --> doShift "web" <+> doRaise,
      className =? "chromium-browser" --> doShift "web" <+> doRaise,
      className =? "mpv" --> doShift "misc" <+> doRaise,
      className =? "thunderbird" --> doShift "mail" <+> doRaise,
      appName =? "Calendar" --> doFloatCenter
      -- , isFullscreen --> doFullFloat
    ]

------------------------------------------------------------------------
-- Startup hook
--
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
myStartupHook :: X ()
myStartupHook = do
  -- spawn "setxkbmap hu"
  spawnOn "mail" "keepassxc"
  let path = "/home/lukacsf/code/wiki/" in spawn $ "ghc --make " <> path <> "site.sh && " <> path <> "./site clean && " <> path <> "./site watch"

-----------------------------------------------------------------------
-- Log hook

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
main :: IO ()
main = do
  xmobar <- spawnPipe "xmobar $HOME/code/dotfiles/xmobar"
  xmonad . ewmh . ewmhFullscreen . docks $
    def
      { terminal = myTerminal,
        focusFollowsMouse = myFocusFollowsMouse,
        clickJustFocuses = myClickJustFocuses,
        borderWidth = myBorderWidth,
        modMask = myModMask,
        workspaces = myWorkspaces,
        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys = myKeys,
        mouseBindings = myMouseBindings,
        layoutHook = onWorkspace "mail" full myLayout,
        manageHook = myManageHook <+> manageDocks,
        handleEventHook = mempty,
        logHook =
          dynamicLogWithPP $
            xmobarPP
              { ppOutput = hPutStrLn xmobar,
                ppCurrent = xmobarColor lightGreen "" . wrap "[" "]",
                ppVisible = xmobarColor darkPurple "",
                ppHidden = xmobarColor lightBeige "" . wrap "" "^",
                ppHiddenNoWindows = xmobarColor lightBeige "",
                ppUrgent = xmobarColor darkRed "" . wrap "!" "!",
                ppTitle = xmobarColor lightBeige "" . shorten 60,
                ppSep = xmobarColor lightBeige "" " | ",
                ppExtras = [windowCount],
                ppOrder = \(ws : l : t : ex) -> ws : l : ex ++ [t]
              },
        startupHook = myStartupHook
      }

-- Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-q            Close/kill the focused window",
      "mod-f            Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Space        Move focus to the next window",
      "mod-Shift-Spacw  Move focus to the previous window",
      "mod-j            Move focus to the next window",
      "mod-k            Move focus to the previous window",
      "mod-m            Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-j  Swap the focused window with the next window",
      "mod-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-shift-k   Increment the number of windows in the master area",
      "mod-shift-j   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-z  Quit xmonad",
      "mod-z        Restart xmonad",
      "",
      "-- Workspaces & screens",
      "mod-[1..9]   Switch to workSpace N",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
