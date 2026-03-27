; <<Copyright (C)  2022 Abel Granados>>
; https://es.fiverr.com/abelgranados
#Include, fileGetProperties.ahk
Process, Priority, , High
SetBatchLines, -1
ListLines, Off
SendMode, Event
CoordMode, Pixel, Window


reset := false

imgLetters := []

Loop, Files, imgLetters/*.png, f 
{
	array := StrSplit(A_LoopFileName , "_")
	imgLetters[A_Index] := {handle:LoadPicture(A_LoopFileLongPath), key:array[1]} 
}

imgBarHandle := LoadPicture("img\bar.png")

;w221, h52
;container := crearRegion(300, 300, 300 + 221, 300 + 52)
;container := crearRegion(852, 892, 852 + 221, 892 + 52)

;w214 h9dd
;spacebar := crearRegion(300, 345, 300 + 214, 345 + 9)
;spacebar := crearRegion(852, 932, 851 + 214, 931 + 9)

keyRegion := []
containerX := container.x1, containerY := container.y1, squareWidth := 54, squareHeight := 30 ;19
marginRigth := 0

xPrev := containerX - 1
yPrev := containerY - 1

	loop, 4 {
		n := keyRegion.push(crearRegion(xPrev + 1, yPrev + 1, xPrev + squareWidth, yPrev + squareHeight))
		xPrev := keyRegion[n].x2 + marginRigth
	}

regiones := []
regiones.push(spacebar)
regiones.push(keyRegion*)



Hotkey, ^f12, showLayout
Hotkey, ^f11, toggleScript, P1

MsgBox, Instructions:`nCtrl + f11 toggle on/off script`nCtrl + f12 shows/hide overlay`n 1 toggle on\off test to show keys


return

1::
	if(tToggle := !tToggle){
		setTimer, tTest, 200
		return
	}
	 setTimer, tTest, Off
return


tTest(){

	Global keyRegion

	sep := ""
	msg := ""
	loop, 4 {

		key := identifyKey(keyRegion[A_Index])
		msg .= sep . key
		sep := " - "
	}

	showNotificationMsg("keyArray = " . msg)

}

toggleScript:
	if(toggleScript:=!toggleScript){
		setTimer, script, 10
		showNotificationMsg("Script On")
		return
	}

	setTimer, script, Off
	showNotificationMsg("Script will Off")
	reset := true
return

showLayout:

	if (toggleLayout:=!toggleLayout){
		
		winActiva := WinExist("A")
		idGrafico := crearColeccionGraficos(regiones.Count())
		dibujarColeccionRectangulos(idGrafico, regiones, winActiva)

	}else{

		destruirColeccionGraficos(idGrafico)
		idGrafico := []
	
	}

return


script(){

	Global
	static keyArr := [], currentKey := 1, index := 1, spacebarNeded := 1

	if(reset){
		spacebarNeded := 1
		currentKey := 1
		index := 1
		keyArr := []
		reset := false
	}


	if(minigameClosed()){
		spacebarNeded := 1
		currentKey := 1
		index := 1
		keyArr := []
		showNotificationMsg("Minigame closed")
		return
	}

	if(spacebarNeded && spacebarReached()){
		hSend("{Space}")
		spacebarNeded := false
	}

	if(keyArr.Count() < 4){
		
		key := identifyKey(keyRegion[index])	
		if(key){
			keyArr.Push(key)
			index++
		}

	}

	sep := ""
	msg := ""
	loop, % keyArr.Count() {
	
		msg .= sep . keyArr[A_Index]
		sep := " - "

	}

	showNotificationMsg("keyArray = " . msg)

	if(currentKey <= keyArr.Count()){
		keySended := sendKeyControlled(keyArr[currentKey])
		if(keySended){
			currentKey++
		}
	}

}


;#################### Script functions
sendKeyControlled(key){
	
	static tKeyIntervalo := randomValue(40, 80), tLimite := 0

	if(A_tickCount >= tLimite){
	
		Send, % key
		;ControlSend, edit1, % key, ahk_class Notepad
		;reset
		tLimite := A_TickCount + tKeyIntervalo
		SetKeyDelay, 0, randomValue(30, 100)
		tKeyIntervalo := randomValue(40, 80)
		return 1 ;key sended
	}
	
	return false ;key waiting
}
	

minigameClosed(){
	
	Global spacebar
	
	;Color when the bar appear. BGR format 
	PixelSearch, fx, fy, spacebar.x1, spacebar.y1, spacebar.x2, spacebar.y2, 0x486BFF, 32, fast
	if(!ErrorLevel){
		return false	
	}

	;color when the bar is reached
	PixelSearch, fx, fy, spacebar.x1, spacebar.y1, spacebar.x2, spacebar.y2, 0x24A3FE, 32, fast
	if(!ErrorLevel){
		return false	
	}
	
	return true
}

spacebarReached(){

	Global spacebar, imgBarHandle
	ImageSearch, x, y, spacebar.x1, spacebar.y1, spacebar.x2, spacebar.y2, % "*16 HBITMAP:*" . imgBarHandle
	if(ErrorLevel){
		return false
	}

	return true

}

identifyKey(region){

	Global imgKey

	loop, % imgKey.Count(){
		
		ImageSearch,,, region.x1, region.y1, region.x2, region.y2, % "*96 HBITMAP:*" . imgKey[A_Index].handle
		
		if(!ErrorLevel){
			return imgKey[A_Index].key
		}
	
	}
	
	return false

}

hSend(key){

	SetKeyDelay, randomValue(30, 60), randomValue(30, 60)
	;ControlSend, edit1, % key, ahk_class Notepad
	Send, % key

}











;#########################################################################
crearRegion(x1, y1, x2, y2){

	if (x1<0 or y1<0 or x2<0 or y2<0){
		return 0
	}

	if(x2 < x1){
		temp := x1
		x1 := x2
		x2 := temp
	}

	if(y2 < y1){
		temp := y1
		y1 := y2
		y2 := temp
	}

	return {"x1":x1, "y1":y1, "x2":x2, "y2":y2}

}



crearGrafico(cc:="0x3CFF3C") {

	Gui, New, +HwndGrafico  +AlwaysOnTop -Caption +E0x00000020 +E0x08000000
	Gui, Color, %cc%
	return Grafico

}

crearColeccionGraficos(cantidad){

	ids := []
	loop, %cantidad%
		ids[A_Index] := crearGrafico()
	
	return ids
}


dibujarRectangulo(winHwnd:=0, punto:=0, hwndGrafico:=0, x1:=0, y1:=0, x2:=0, y2:=0, borde:=2){
    
    if (!hwndGrafico or x1<0 or y1<0 or x2<0 or y2<0){
        return 1
    }

    addX := 0, addY := 0 
    if (winHwnd != 0){
        
        win := WinExist("ahk_id " winHwnd)
        if !win
            return 2
        
        WinGetPos, wx, wy, , , ahk_id %win%
      	addX := wx
       	addY := wy
    }

    if(punto != 0){
        addX += punto.x
        addY += punto.y
    }

    x1+=addX
    y1+=addY
    x2+=addX
    y2+=addY

    w := x2 - x1
    h := y2 - y1
    w2:= w - borde
    h2:= h - borde
  
    Gui, %hwndGrafico%: Show, w%w% h%h% x%x1% y%y1% NA
    WinSet, Transparent, 255
    WinSet, Region, 0-0 %w%-0 %w%-%h% 0-%h% 0-0 %borde%-%borde% %w2%-%borde% %w2%-%h2% %borde%-%h2% %borde%-%borde%, ahk_id %hwndGrafico%

}

dibujarColeccionRectangulos(idGraficos, regiones, winHwnd:=0, punto:=0){

	loop, % idGraficos.Count()
		dibujarRectangulo(winHwnd, punto, idGraficos[A_Index], regiones[A_Index].x1, regiones[A_Index].y1, regiones[A_Index].x2, regiones[A_Index].y2)
	
}

destruirGrafico(hwndGrafico){
	
	if (!hwndGrafico)
		return

	Gui, %hwndGrafico%:Destroy
}

destruirColeccionGraficos(ids){
	
	loop, % ids.Count()
		destruirGrafico(ids[A_Index]) 
	
}



distribucionAlObjetivo(ini, objetivo, fin){
  
    Random, izq, ini, objetivo
    Random, der, objetivo, fin
    Random, cerca, izq, der
    return cerca

}

showNotificationMsg(msg:="", centrar :=0){
    
   	CoordMode, ToolTip, Window
    
    if(centrar){
    	WinGetPos, X, Y, Width, Height, A
    	Tooltip, % msg, Width//2, Height//2, 1
    }else{
    	Tooltip, % msg , , , 1
    }

    setTimer, quitarTooltip, -2000
    return

    quitarTooltip:
        Tooltip, , , , 1
    return

}

randomSleep(min:=30, max:=1000){
    Sleep,  distribucionAlObjetivo(min, ((min+max)//2), max)
}

randomValue(min, max){
    return  distribucionAlObjetivo(min, ((min+max)//2), max)
}