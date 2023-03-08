import gi
from os import system as run_cmd

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class Handler:
  def onDestroy(self, *args):
    Gtk.main_quit()
    
  def loadVolume(self,cr,txtbox):
    self.volumebox = cr
    
    vol = run_cmd("/opt/bin/volume-level.sh") >> 8
    
    voldisp = str(vol) + "%" if not vol == 255 else "Muted"
    
    self.setVolumeDisplay(voldisp)
  
  def loadPluto(self,button):
    run_cmd("/opt/bin/pluto.sh")
  
  def loadYoutube(self,button):
    run_cmd("/opt/bin/youtube.sh")
  
  def loadTV(self,button):
    run_cmd("/opt/bin/tv.sh")
  
  def loadRadio(self,button):
    run_cmd("/opt/bin/radio-gui.sh")
  
  def volumeUp(self,button):
    vol = run_cmd("/opt/bin/volume-up.sh") >> 8
    
    voldisp = str(vol) + "%"
    
    self.setVolumeDisplay(voldisp)
  
  def volumeDown(self,button):
    vol = run_cmd("/opt/bin/volume-down.sh") >> 8
    
    voldisp = str(vol) + "%"
    
    self.setVolumeDisplay(voldisp)
  
  def volumeMute(self,button):
    vol = run_cmd("/opt/bin/volume-mute.sh") >> 8
    
    voldisp = str(vol) + "%" if not vol == 255  else "Muted"
    
    self.setVolumeDisplay(voldisp)
  
  def setVolumeDisplay(self,value):
    self.volumebox.set_text(value)


builder = Gtk.Builder()
builder.add_from_file("tv-app.glade")
builder.connect_signals(Handler())

window = builder.get_object("win1")
window.show_all()

Gtk.main()
