// Control of the TEM from within DigitalMicrograph
//数字显微照片中TEM的控制
// Designed for use with modern TEMs which support ethernet communication, such as FEI Osiris/Tecnai and JEOL 1400,2100,2200, ARM 200. 
// 设计用于支持以太网通信的现代TEM，如FEI Osiris/Tecnai和JEOL 140021002200、ARM 200。
// Not supported are FASTem instruments and others which use serial communication. There is an early JEOL counterpart to this script
不支持FAIST仪器和其他使用串行通信的仪器。有一个早期的JOOL对应于这个脚本。
// called 2010F Control Palette available from this site.
从这个站点调用2010f控制面板。
// D. R. G. Mitchell, adminnospam@dmscripting.com, remove the nospam to make this work
D R G米切尔，adminnospam”dmscripting.com，remove the nospam to make this work
// version:20130114, v2.0, January 2013., www.dmscripting.com
版本：20130114，v2.0，一月2013.，www.dmscripting.com
// Acknowledgements: Thanks to Christoph Gammer and Phil Ahrenkiel for assistance with 'em' microscope control commands.
感谢：感谢Christoph Gammer和Phil Ahrenkiel为他们的显微镜控制命令提供帮助。

// Default settings stored in the Global Info under File/Global Info/Tags/TEM Control/Default Settings.
文件/全局信息/标签/TEM控制/默认设置下的全局信息中存储的默认设置。
// The current settings can be saved as the new default values by closing the dialog with the ALT key held down.
通过关闭带有ALT键的对话框，当前设置可以保存为新的默认值。

number defaultstagejiggleinnm=50 // the amount by which the stage is jiggled in nm (ALT + any stage shift) to eliminate backlash
在Nm（ALT+任何阶段移位）中跳汰阶段消除消隙的量
if(!getpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",defaultstagejiggleinnm))
{
	setpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",defaultstagejiggleinnm)
}
// 如果获取不到持久数字注释 就 设置持久数字注释 

number defaultzaxisjiggleinnm=400 // the amount by which the z height is jiggled in nm (ALT + Z Up or Z Down) to eliminate backlash
//Z 轴抖动
if(!getpersistentnumbernote("TEM Control:Default Values:Z Axis Jiggle (nm)",defaultzaxisjiggleinnm))
{
	setpersistentnumbernote("TEM Control:Default Values:Z Axis Jiggle (nm)",defaultzaxisjiggleinnm)
}


number defaultbrightnessstep=200 // arbitrary value

if(!getpersistentnumbernote("TEM Control:Default Values:Brightness Step Size",defaultbrightnessstep))
	{
		setpersistentnumbernote("TEM Control:Default Values:Brightness Step Size",defaultbrightnessstep)
	}


number defaultfocusstep=50 // value of focus change in nm

if(!getpersistentnumbernote("TEM Control:Default Values:Focus Step Size (nm)",defaultfocusstep))
	{
		setpersistentnumbernote("TEM Control:Default Values:Focus Step Size (nm)",defaultfocusstep)
	}



number defaultstageshiftstepvalue=100 // amount the stage is shifted in nm

if(!getpersistentnumbernote("TEM Control:Default Values:Stage Shift Step Size (nm)",defaultstageshiftstepvalue))
	{
		setpersistentnumbernote("TEM Control:Default Values:Stage Shift Step Size (nm)",defaultstageshiftstepvalue)
	}


number defaultzshiftstepvalue=200 // amount the z height is changed in nm

if(!getpersistentnumbernote("TEM Control:Default Values:Z Shift Step Size (nm)",defaultzshiftstepvalue))
	{
		setpersistentnumbernote("TEM Control:Default Values:Z Shift Step Size (nm)",defaultzshiftstepvalue)
	}



number defaultimageshiftstepvalue=50 // amount the image shift is chantged in nm

if(!getpersistentnumbernote("TEM Control:Default Values:Image Shift Step Size (nm)",defaultimageshiftstepvalue))
	{
		setpersistentnumbernote("TEM Control:Default Values:Image Shift Step Size (nm)",defaultimageshiftstepvalue)
	}


number defaultstagetiltstepvalue=0.1 // amount the stage alpha or beta are changed in degrees

if(!getpersistentnumbernote("TEM Control:Default Values:Stage Tilt Step Size (deg)",defaultstagetiltstepvalue))
	{
		setpersistentnumbernote("TEM Control:Default Values:Stage Tilt Step Size (deg)",defaultstagetiltstepvalue)
	}



// Functions invoked by pressing the various buttons

class TEMControlDialog : uiframe
{


void stagedown( object self)
	{
		// Get the step size from the field
	
		number stageshiftstep=dlggetvalue(self.lookupelement("stageshiftstepfield"))
		stageshiftstep=stageshiftstep/1000
		

		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetstagexy(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				number stagejigglestep
				getpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",stagejigglestep)
				stagejigglestep=stagejigglestep/1000
				
				
				// Jiggle x
				
				emsetstagex(currentxshift+stagejigglestep)
				delay(30)
				emsetstagex(currentxshift-(2*stagejigglestep))
				delay(30)
				emsetstagex(currentxshift)
				
								
				// Jiggle y
				
				emsetstagey(currentyshift+stagejigglestep)
				delay(30)
				emsetstagey(currentyshift-(2*stagejigglestep))
				delay(30)
				emsetstagey(currentyshift)

				return
			}

		// Set the image shift to increment in the up direction
		
		emsetstagex(currentxshift-stageshiftstep)
	}
	
	

void stageup( object self)
	{
		// Get the step size from the field
	
		number stageshiftstep=dlggetvalue(self.lookupelement("stageshiftstepfield"))
		stageshiftstep=stageshiftstep/1000 // step size in the dialog is in nm - stage movement is in um
		

		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetstagexy(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				number stagejigglestep
				getpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",stagejigglestep)
				stagejigglestep=stagejigglestep/1000
				
				
				// Jiggle x
				
				emsetstagex(currentxshift+stagejigglestep)
				delay(30)
				emsetstagex(currentxshift-(2*stagejigglestep))
				delay(30)
				emsetstagex(currentxshift)
				
								
				// Jiggle y
				
				emsetstagey(currentyshift+stagejigglestep)
				delay(30)
				emsetstagey(currentyshift-(2*stagejigglestep))
				delay(30)
				emsetstagey(currentyshift)

				return
			}

		// Set the image shift to increment in the up direction
		
		emsetstagex(currentxshift+stageshiftstep)
	}


void stageleft( object self)
	{
		// Get the step size from the field
	
		number stageshiftstep=dlggetvalue(self.lookupelement("stageshiftstepfield"))
		stageshiftstep=stageshiftstep/1000


		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetstagexy(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				number stagejigglestep
				getpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",stagejigglestep)
				stagejigglestep=stagejigglestep/1000
				
				
				// Jiggle x
				
				emsetstagex(currentxshift+stagejigglestep)
				delay(30)
				emsetstagex(currentxshift-(2*stagejigglestep))
				delay(30)
				emsetstagex(currentxshift)
				
								
				// Jiggle y
				
				emsetstagey(currentyshift+stagejigglestep)
				delay(30)
				emsetstagey(currentyshift-(2*stagejigglestep))
				delay(30)
				emsetstagey(currentyshift)

				return
			}


		// Set the image shift to increment in the up direction

		emsetstagey(currentyshift+stageshiftstep)
	}


void stageright( object self)
	{
		// Get the step size from the field
	
		number stageshiftstep=dlggetvalue(self.lookupelement("stageshiftstepfield"))
		stageshiftstep=stageshiftstep/1000


		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetstagexy(currentxshift, currentyshift)
		
		
		// If ALT is held down - jiggle the stage
		
		if(optiondown())
			{
				number stagejigglestep
				getpersistentnumbernote("TEM Control:Default Values:Stage Jiggle (nm)",stagejigglestep)
				stagejigglestep=stagejigglestep/1000
				
				
				// Jiggle x
				
				emsetstagex(currentxshift+stagejigglestep)
				delay(30)
				emsetstagex(currentxshift-(2*stagejigglestep))
				delay(30)
				emsetstagex(currentxshift)
				
								
				// Jiggle y
				
				emsetstagey(currentyshift+stagejigglestep)
				delay(30)
				emsetstagey(currentyshift-(2*stagejigglestep))
				delay(30)
				emsetstagey(currentyshift)

				return
			}


		// Set the image shift to increment in the up direction

		emsetstagey(currentyshift-stageshiftstep)
	}


void imageup( object self)
	{
		// Get the step size from the field
	
		number imageshiftstep=dlggetvalue(self.lookupelement("imageshiftstepfield"))
		
		
		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetimageshift(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				if(!twobuttondialog("Reset Image Shifts in x and y?","Reset","Cancel"))	return
				
				emsetimageshift(0,0)
				return
			}

		// Set the image shift to increment in the up direction
		
		emsetimageshift((currentxshift-imageshiftstep),currentyshift)
	}
	
	
void imagedown( object self)
	{
		// Get the step size from the field
	
		number imageshiftstep=dlggetvalue(self.lookupelement("imageshiftstepfield"))
		
		
		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetimageshift(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				if(!twobuttondialog("Reset Image Shifts in x and y?","Reset","Cancel"))	return
				
				emsetimageshift(0,0)
				return
			}


		// Set the image shift to increment in the up direction
		
		emsetimageshift((currentxshift+imageshiftstep),currentyshift)

	}
	
	
void imageleft( object self)
	{
		// Get the step size from the field
	
		number imageshiftstep=dlggetvalue(self.lookupelement("imageshiftstepfield"))
		
		
		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetimageshift(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				if(!twobuttondialog("Reset Image Shifts in x and y?","Reset","Cancel"))	return
				
				emsetimageshift(0,0)
				return
			}


		// Set the image shift to increment in the up direction
		
		emsetimageshift(currentxshift,(currentyshift-imageshiftstep))

	}


void imageright( object self)
	{
		// Get the step size from the field
	
		number imageshiftstep=dlggetvalue(self.lookupelement("imageshiftstepfield"))
		
		
		// Source the current image shifts
		
		number currentxshift, currentyshift
		emgetimageshift(currentxshift, currentyshift)
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				if(!twobuttondialog("Reset Image Shifts in x and y?","Reset","Cancel"))	return
				
				emsetimageshift(0,0)
				return
			}


		// Set the image shift to increment in the up direction
		
		emsetimageshift(currentxshift,(currentyshift+imageshiftstep))
	}


void zup(object self)
	{
		// Get the step size from the field
	
		number zshiftstep=dlggetvalue(self.lookupelement("zshiftstepfield"))
		zshiftstep=zshiftstep/1000 // field is in nm, stage movement is in um
		
		
		// Source the current image shifts
		
		number currentz=emgetstagez()
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				number zaxisjiggleinnm
				getpersistentnumbernote("TEM Control:Default Values:Z Axis Jiggle (nm)",zaxisjiggleinnm)
				number zaxisjiggleinum=zaxisjiggleinnm/1000
				
				// Jiggle x stage z

				emsetstagez(currentz+zaxisjiggleinum)
				delay(30)
				emsetstagez(currentz-(2*zaxisjiggleinum))
				delay(30)				
				emsetstagez(currentz)
				return
			}


		// Set the image shift to increment in the up direction

		emsetstagez(currentz+zshiftstep)
}


void zdown(object self)
	{
		// Get the step size from the field
	
		number zshiftstep=dlggetvalue(self.lookupelement("zshiftstepfield"))
		zshiftstep=zshiftstep/1000 // field is in nm, stage movement is in um
		
		
		// Source the current image shifts
		
		number currentz=emgetstagez()
		
		
		// If ALT is held down - reset all shifts
		
		if(optiondown())
			{
				number zaxisjiggleinnm
				getpersistentnumbernote("TEM Control:Default Values:Z Axis Jiggle (nm)",zaxisjiggleinnm)
				number zaxisjiggleinum=zaxisjiggleinnm/1000
				
				// Jiggle x stage z

				emsetstagez(currentz+zaxisjiggleinum)
				delay(30)
				emsetstagez(currentz-(2*zaxisjiggleinum))
				delay(30)				
				emsetstagez(currentz)
				return
			}


		// Set the image shift to increment in the up direction

		emsetstagez(currentz-zshiftstep)
	}


void upbright( object self)
		{
			number currentbrightness=emgetbrightness()
			number brightstep=dlggetvalue(self.lookupelement("brightnessstepfield"))
			emsetbrightness(currentbrightness+brightstep)
		}

	
void downbright( object self)
		{
			number currentbrightness=emgetbrightness()
			number brightstep=dlggetvalue(self.lookupelement("brightnessstepfield"))
			emsetbrightness(currentbrightness-brightstep)
		}


void upmag( object self)
		{
			number currentmagindex=emgetmagindex()
			number newmagindex=currentmagindex+1
			try
			emsetmagindex(newmagindex)
			catch
			return

		}


void downmag( object self)
		{
			number currentmagindex=emgetmagindex()
			number newmagindex=currentmagindex-1
			try
			emsetmagindex(newmagindex)
			catch
			return
		}


void upspot( object self)
		{
			number currentspot=emgetspotsize()
			emsetspotsize(currentspot+1)
		}


void downspot( object self)
		{
			number currentspot=emgetspotsize()
			emsetspotsize(currentspot-1)
		}


void upfocus( object self)
		{
			number focusstep=dlggetvalue(self.lookupelement("focusstepfield"))
			emchangefocus(focusstep)
		}


void downfocus( object self)
		{
			number focusstep=dlggetvalue(self.lookupelement("focusstepfield"))
			emchangefocus(focusstep*-1)
		}
	
	
void alphaplus(object self)
		{
				number anglestep=dlggetvalue(self.lookupelement("stagetiltstepfield"))
				number currentangle=emgetstagealpha()
				emsetstagealpha(currentangle+anglestep)
		}
	
	
void alphaminus(object self)
		{
				number anglestep=dlggetvalue(self.lookupelement("stagetiltstepfield"))
				number currentangle=emgetstagealpha()
				emsetstagealpha(currentangle-anglestep)
		}
		
		
void betaplus(object self)
	{
			// Use a try/catch handler to read the stage beta - if a single tilt holder is in use, it will generate and exception
			// If a double tilt holder is in use, then then it will be read and the new value will be set
			
			number currentangle
			
			try
			{
				currentangle=emgetstagebeta()
			}
		catch
			{
				showalert("A double tilt holder must be in use.",2)
				return
			}
		
				number anglestep=dlggetvalue(self.lookupelement("stagetiltstepfield"))
				emsetstagebeta(currentangle+anglestep)
	}
	
	
void betaminus(object self)
	{
		// Use a try/catch handler to read the stage beta - if a single tilt holder is in use, it will generate and exception
		// If a double tilt holder is in use, then then it will be read and the new value will be set
			
		number currentangle
			
		try
			{
				currentangle=emgetstagebeta()
			}
		catch
			{
				showalert("A double tilt holder must be in use.",2)
				return
			}
		
		number anglestep=dlggetvalue(self.lookupelement("stagetiltstepfield"))
		emsetstagebeta(currentangle-anglestep)
	}
	
	
void abouttoclosedocument(object self)
	{
		// If the ALT key is held down save the current dialog settings as the new defaults

			if(optiondown()) 
				{
					number imageshiftstep=dlggetvalue(self.lookupelement("imageshiftstepfield"))
					number stageshiftstep=dlggetvalue(self.lookupelement("stageshiftstepfield"))
					number zshiftstep=dlggetvalue(self.lookupelement("zshiftstepfield"))

					number stagetiltstep=dlggetvalue(self.lookupelement("stagetiltstepfield"))
					number brightnessstep=dlggetvalue(self.lookupelement("brightnessstepfield"))
					number focusstep=dlggetvalue(self.lookupelement("focusstepfield"))


					if(twobuttondialog("Save the current settings as the new defaults?", "Save", "Cancel"))
						{
							setpersistentnumbernote("TEM Control:Default Values:Image Shift Step Size (nm)",imageshiftstep)
							setpersistentnumbernote("TEM Control:Default Values:Stage Shift Step Size (nm)",stageshiftstep)
							setpersistentnumbernote("TEM Control:Default Values:Z Shift Step Size (nm)",zshiftstep)

							setpersistentnumbernote("TEM Control:Default Values:Stage Tilt Step Size (deg)",stagetiltstep)
							setpersistentnumbernote("TEM Control:Default Values:Brightness Step Size",brightnessstep)
							setpersistentnumbernote("TEM Control:Default Values:Focus Step Size (nm)",focusstep)
							
							showalert("Current values were saved as new defaults.",2)					
						}
				}


				// Get the dialog position

				number xpos, ypos
				documentwindow dialogwindow=getframewindow(self)
				windowgetframeposition(dialogwindow, xpos, ypos)


				// Checks to make sure the dialog is not outside the screen viewing area 
				// this can happen if the dialog is accidentally maximised and then closed.
				// If the position is OK, then it is saved.

				number screenx, screeny
				getscreensize(screenx, screeny)
				if(xpos<0) xpos=142 // This keeps it out from behind the left palette column in GMS 1.x
				if(xpos>screenx) xpos=screenx-(screenx/10)
				if(ypos<0) ypos=20 // This keeps it below the top menu in GMS 1.x
				if(ypos>screeny) ypos=screeny-(screeny/5) // If the dialog is off the right hand edge - put it at 80% of screen width

				setpersistentnumbernote("TEM Control:Dialog Position:Left",xpos)
				setpersistentnumbernote("TEM Control:Dialog Position:Right",ypos)
}
	

// End of Class methods

}


// Control Palette creation functions

TagGroup MakeLabels()
	{
		TagGroup label1 = DLGCreateLabel("D. R. G. Mitchell, v2.0, Jan. 2013")
		label1.dlgexternalpadding(0,3)
		return label1
	}


TagGroup MakeButtons()
	{
		// Box SHIFT contains the Image shift buttons

		taggroup boxSHIFT_items
		taggroup boxSHIFT=dlgcreatebox("  Image Shift  ", boxSHIFT_items)
		taggroup pushbuttons

		TagGroup IUpButton = DLGCreatePushButton("I.Up", "imageup").DLGSide("Top");
		TagGroup ILeftButton = DLGCreatePushButton("I.Left", "imageleft").DLGSide("Centre");
		TagGroup IRightButton = DLGCreatePushButton("I.Right", "imageright").DLGSide("Centre");
		TagGroup IDownButton = DLGCreatePushButton("I.Down", "imagedown").DLGSide("Bottom");
		
		number smallfieldwidth=6 // controls the width of the top 4 fields in the dialog
		number imageshiftstepvalue
		getpersistentnumbernote("TEM Control:Default Values:Image Shift Step Size (nm)",imageshiftstepvalue)
		taggroup imageshiftstepfield=dlgcreaterealfield(imageshiftstepvalue,smallfieldwidth,4).dlgidentifier("imageshiftstepfield")

		IUpButton.dlgexternalpadding(0,5).dlginternalpadding(7,0)
		ILeftButton.dlgexternalpadding(10,0).dlginternalpadding(5,0)
		IRightButton.dlgexternalpadding(10,0).dlginternalpadding(1,0)
		IDownButton.dlgexternalpadding(0,5)

		pushbuttons=dlggroupitems(ILeftButton, imageshiftstepfield,IRightButton).dlgtablelayout(3,1,0)									
		taggroup pushbuttons1=dlggroupitems(IUpButton, pushbuttons,IDownButton)
		boxSHIFT_items.dlgaddelement(pushbuttons1)


	// Box STAGE contains the Stage shift buttons

		taggroup boxSTAGE_items
		taggroup boxSTAGE=dlgcreatebox("  Stage Shift",boxSTAGE_items)
		taggroup pushbuttons2
		TagGroup SUpButton = DLGCreatePushButton("S.Up", "stageup").DLGSide("Top");
		TagGroup SRightButton = DLGCreatePushButton("S.Right", "stageright").DLGSide("Left");
		TagGroup SLeftButton = DLGCreatePushButton("S.Left", "stageleft").DLGSide("Right");
		TagGroup SDownButton = DLGCreatePushButton("S.Down","stagedown").DLGSide("Bottom");

		SLeftButton.dlgexternalpadding(10,0).dlginternalpadding(5,0)
		SRightButton.dlgexternalpadding(10,0).dlginternalpadding(2,0)
		SUpButton.dlgexternalpadding(0,5).dlginternalpadding(7,0)
		SDownButton.dlgexternalpadding(0,5)
		
		number stageshiftstepvalue
		getpersistentnumbernote("TEM Control:Default Values:Stage Shift Step Size (nm)",stageshiftstepvalue)
		taggroup stageshiftstepfield=dlgcreaterealfield(stageshiftstepvalue,smallfieldwidth,4).dlgidentifier("stageshiftstepfield")

		pushbuttons2=dlggroupitems(SLeftButton, stageshiftstepfield,SRightButton).dlgtablelayout(3,1,0)
		taggroup pushbuttons3=dlggroupitems(SUpButton, pushbuttons2,sdownbutton).dlgtablelayout(1,3,0)
		
		number zshiftstepvalue
		getpersistentnumbernote("TEM Control:Default Values:Z Shift Step Size (nm)",zshiftstepvalue)
		taggroup zshiftstepfield=dlgcreaterealfield(zshiftstepvalue,smallfieldwidth,4).dlgidentifier("zshiftstepfield").dlgexternalpadding(12,10)
		
		taggroup zminusbutton=dlgcreatepushbutton("Z Up","zup").dlginternalpadding(8,0)
		taggroup zplusbutton=dlgcreatepushbutton("Z Down","zdown").dlginternalpadding(0,0)
		taggroup zbuttongroup=dlggroupitems(zminusbutton,zshiftstepfield, zplusbutton).dlgtablelayout(3,1,0)
		
		taggroup allshiftgroup=dlggroupitems(pushbuttons3,zbuttongroup).dlgtablelayout(1,2,0)
		boxSTAGE_items.dlgaddelement(allshiftgroup)


	// Box Tilt contains the Stage tilt buttons

		taggroup boxTilt_items
		taggroup boxTilt=dlgcreatebox("  Stage Tilt",boxtilt_items)
		taggroup pushbuttons4
		TagGroup alphaplusButton = DLGCreatePushButton("Alpha +", "alphaplus").DLGSide("Top");
		TagGroup betaminusButton = DLGCreatePushButton("Beta -", "betaminus").DLGSide("Left");
		TagGroup betaplusButton = DLGCreatePushButton("Beta +", "betaplus").DLGSide("Right");
		TagGroup alphaminusButton = DLGCreatePushButton("Alpha -", "alphaminus").DLGSide("Bottom");

		betaminusButton.dlgexternalpadding(10,0).dlginternalpadding(4,0)
		betaplusButton.dlgexternalpadding(10,0).dlginternalpadding(3,0)
		alphaplusButton.dlgexternalpadding(0,5).dlginternalpadding(1,0)
		alphaminusButton.dlgexternalpadding(0,5).dlginternalpadding(3,0)

		number stagetiltstepvalue
		getpersistentnumbernote("TEM Control:Default Values:Stage Tilt Step Size (deg)",stagetiltstepvalue)	
		taggroup stagetiltstepfield=dlgcreaterealfield(stagetiltstepvalue,smallfieldwidth,4).dlgidentifier("stagetiltstepfield")

		pushbuttons4=dlggroupitems(betaminusbutton, stagetiltstepfield,betaplusbutton).dlgtablelayout(3,1,0)
		taggroup pushbuttons5=dlggroupitems(alphaplusbutton, pushbuttons4,alphaminusbutton)
		pushbuttons5.dlgtablelayout(1,3,0)
		boxTilt_items.dlgaddelement(pushbuttons5)


	// Box SCOPE contains the microscope control buttons - mag, brightness etc

		taggroup boxSCOPE_items
		taggroup boxSCOPE=dlgcreatebox("  Microscope Control  ", boxSCOPE_items)

		Taggroup brightupbutton=dlgcreatepushbutton("Bright Up", "upbright").DLGSide("Left")
		brightupbutton.dlgexternalpadding(8,5).dlginternalpadding(8,0)
		TagGroup brightdownButton = DLGCreatePushButton("Bright Down", "downbright").DLGanchor("Right");
		brightdownbutton.dlgexternalpadding(8,5)

		taggroup pushbuttons7=dlggroupitems(brightupbutton,brightdownbutton)
		pushbuttons7.dlgtablelayout(3,1,0)
		boxSCOPE_items.dlgaddelement(pushbuttons7)

		TagGroup label1 = DLGCreateLabel("Step")
		label1.dlgexternalpadding(28,0)
		
		number brightstepsize
		getpersistentnumbernote("TEM Control:Default Values:Brightness Step Size",brightstepsize)

		taggroup realfield1 = DLGCreateRealField(brightstepsize, 8, 3).dlgidentifier("brightnessstepfield")
		realfield1.dlgexternalpadding(28,0)	

		taggroup labelbox1=dlggroupitems(label1, realfield1)
		labelbox1.dlgtablelayout(2,3,0)
		boxSCOPE_items.dlgaddelement(labelbox1)

		Taggroup focusupbutton=dlgcreatepushbutton("Focus Up", "upfocus").DLGSide("Left")
		focusupbutton.dlgexternalpadding(9,0).dlginternalpadding(7,0)
		TagGroup focusdownButton = DLGCreatePushButton("Focus Down", "downfocus").DLGanchor("Right");
		focusdownbutton.dlgexternalpadding(9,0)

		taggroup pushbuttons8=dlggroupitems(focusupbutton,focusdownbutton)
		pushbuttons8.dlgtablelayout(3,1,0)
		boxSCOPE_items.dlgaddelement(pushbuttons8)

		TagGroup label2 = DLGCreateLabel("Step")
		label2.dlgexternalpadding(26,0)
		
		number focusstepsize
		getpersistentnumbernote("TEM Control:Default Values:Focus Step Size (nm)",focusstepsize)
		
		taggroup realfield2 = DLGCreateRealField(focusstepsize, 8,4).dlgidentifier("focusstepfield").dlgexternalpadding(26,5)	
		dlgvalue(realfield2,defaultfocusstep)
		taggroup labelbox2=dlggroupitems(label2, realfield2)
		labelbox2.dlgtablelayout(2,3,0)
		boxSCOPE_items.dlgaddelement(labelbox2)

		Taggroup spotupbutton=dlgcreatepushbutton("Spot Up", "upspot").DLGSide("Left")
		spotupbutton.dlgexternalpadding(8,0).dlginternalpadding(11,0)
		TagGroup spotdownButton = DLGCreatePushButton("Spot Down", "downspot").DLGanchor("Right");
		spotdownbutton.dlgexternalpadding(8,0).dlginternalpadding(4,0)

		taggroup pushbuttons9=dlggroupitems(spotupbutton,spotdownbutton).dlgtablelayout(3,1,0)
		boxSCOPE_items.dlgaddelement(pushbuttons9)

		Taggroup magupbutton=dlgcreatepushbutton("Mag Up", "upmag").DLGSide("Left")
		magupbutton.dlgexternalpadding(8,5).dlginternalpadding(11,0)
		TagGroup magdownButton = DLGCreatePushButton("Mag Down", "downmag").DLGanchor("Right")
		magdownbutton.dlgexternalpadding(8,10).dlginternalpadding(4,0)

		taggroup pushbuttons10=dlggroupitems(magupbutton,magdownbutton).dlgtablelayout(3,1,0)
		boxSCOPE_items.dlgaddelement(pushbuttons10)
		taggroup boxoutput=dlggroupitems(boxSHIFT, boxTilt,boxSTAGE, boxSCOPE)
		return boxoutput
	}


void CreateTEMControlDialog()
	{
		TagGroup position;
		position = DLGBuildPositionFromApplication()
		TagGroup dialog_items;	
		TagGroup dialog = DLGCreateDialog("Image Controller", dialog_items).dlgposition(position);
		
		dialog_items.DLGAddElement( MakeButtons() );
		dialog_items.DLGAddElement( MakeLabels() );
		object dialog_frame = alloc(TEMControlDialog).init(dialog)
		dialog_frame.display("TEM Control")
		
			
		// Ensure the dialog gets displayed within bounds 
			
		number xpos, ypos, windowx, windowy, screensizex, screensizey
		getpersistentnumbernote("TEM Control:Dialog Position:Left",xpos)
		getpersistentnumbernote("TEM Control:Dialog Position:Right",ypos)

		documentwindow docwin=getdocumentwindow(0)
		docwin.windowsetframeposition(xpos, ypos)
	}


CreateTEMControlDialog()


// Help file output to the results window

result("\n\n\nTEM Control: www.dmscripting.com")
result("\n\nThis script will allow TEM functions to be controlled from within DigitalMicrograph.")
result("\nIt should be compatible with modern TEMs which support the 'em'")
result("\nseries of commands such as FEI Osiris, JEOL 2100 etc.")

result("\n\nUse this script at your own risk. It has been tested on an FEI Osiris - and is provided in good faith.")
result("\nThe author does not accept any responsibility for any damage arising from its use.")

result("\n\nAll the field values are in nm, except for Stage Tilt (degrees) and the Brightness (arbitrary value).")

result("\n\nClicking on any Image Shift button with ALT held down provides the option to zero the X and Y image shifts")

result("\n\nClicking on any Stage Shift button with the ALT key held down will jiggle the stage about its last position.")
result("\nThis may help in settling the stage and reducing stage-induced drift. The size of the jiggle is set in the")
result("\nGlobal Info - see later).")

result("\n\nClicking on either of the Z Up or Z Down buttons with the ALT key held down will jiggle the height about its")
result("\ncurrent position. The size of the the jiggle is set in the Global Info.")

result("\n\nIf you change any of the fields, you can save the new values as the defaults by closing the dialog with")
result("\nthe ALT key held down.")

result("\n\nThe Image and Stage shift buttons map (approximately) to the screen directions on the TEM this was tested on.")
result("\nIf the mapping is wrong for your TEM, look at the button functions in the code - their operation is fairly")
result("\neasy to understand. Flipping directions is simply a matter of subtracting instead of adding steps. Alternatively")
result("\nyou could enter negative steps into the relevant fields. Transposing left/right with up/down is a bit more tricky.")
result("\nIf you get stuck, contact the author for assistance. Note: the alignment between shift up and actual up is approximate")
result("\nand will depend on magnification and how well your TEM was installed.")

result("\n\nTo edit the jiggle values or any of the default settings open the Global Info at:")
result("\nFile/Global Info/Tags/TEM Control/Default Values")