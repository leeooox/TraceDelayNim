import resource/resource
import wNim/[wApp, wFrame, wIcon, wStatusBar, wMenuBar, wMenu, 
  wBitmap, wImage, wPanel, wStaticText, wTextCtrl, wButton, wMessageDialog]
import strutils, math, strformat

type
  # A menu ID in wNim is type of wCommandID (distinct int) or any enum type.
  MenuID = enum 
    idTheory = wIdUser
    idAbout

let app = App()
let frame = Frame(title="Trace Delay Calc",size=(400, 230))
frame.icon = Icon("", 0) # load icon from exe file.

let panel = Panel(frame)

### 
const style = wAlignCentre or wAlignMiddle or wBorderSimple
let label1 = StaticText(panel, label="Trace Length:", style=wAlignRight)
let label2 = StaticText(panel, label="Relative dielectric constant(εr):", style=wAlignRight)
let label3 = StaticText(panel, label="Delay:", style=wAlignRight)
let label4 = StaticText(panel, label="", style=wAlignRight)

let text1 = TextCtrl(panel, value="100",style=wBorderSunken)
let text2 = TextCtrl(panel, value="4.2")#, style=wBorderSunken)
let text3 = TextCtrl(panel, value="")#, style=wBorderSunken)
let button1 = Button(panel, label="Calculate")

let label5 = StaticText(panel, label="mil", style=wAlignLeft)
let label6 = StaticText(panel, label="", style=wAlignLeft)
let label7 = StaticText(panel, label="ps", style=wAlignLeft)
let label8 = StaticText(panel, label="", style=wAlignLeft)

proc layout() =
  panel.autolayout """
    space:2
    V:|~[col1:[label1(label2,label3)]-[label2]-[label3]-[label4]]~|
    V:|~[col2:[text1(text2,text3)]-[text2]-[text3]-[button1]]~|
    V:|~[col3:[label5(label6,label7)]-[label6]-[label7]-[label8]]~|
    H:|-[col1]-[col2]-[col3]-|
"""


let statusBar = StatusBar(frame)
let menuBar = MenuBar(frame)

let menuAbout = Menu(menuBar, "&Help")
let itemTheory = menuAbout.append(idTheory, "Theory", "Theory")
let itemAbout = menuAbout.append(idAbout, "About", "About")


proc GetDelay(len:float, er:float=4): float= 
  result = len*sqrt(er)/12.0

proc calc_dly() = 
  let
    len = parseFloat(text1.getValue())
    er = parseFloat(text2.getValue())
  var
    dly = GetDelay(len,er)

  text3.setValue(fmt"{dly:0.3f}")


######### events bind ########
panel.wEvent_Size do ():
  layout()

button1.wEvent_Button do ():
  calc_dly()

let theory_str = """
It is based on Maxwell equations.  v=1/sqrt(ε0*εr*μ0*μr).
        ε0: Dielectric constant in free space, it is 8.89*10e-12F/m.
        εr: Relative dielectric constant of material.
        μ0: Magnetic permeability in free space, it is 4*π*10e-7H/m.
        μr: Relative magnetic permeability.
"""
frame.idTheory do ():
  let id = MessageDialog(frame, message=theory_str,
    caption="Theory", style=wOk).display()

let about_str = """
Trace delay calculator
  Rev 0.0.1
  It is a free software to calculate trace delay.

  (C) 2020 Signal-integrity.com
"""
frame.idAbout do ():
  let id = MessageDialog(frame, message=about_str,
    caption="About", style=wOk).display()

##### end of event bind ######



layout()
frame.center()
frame.show()
app.mainLoop()
