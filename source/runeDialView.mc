import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class runeDialView extends WatchUi.WatchFace {
    private var _isAwake as Boolean?;
    
    private var animationTicks as Number = 0;
    private var animationTimer;
    private var center;
    private var doFullUpdate = false;
    private var symbolsInitiallized = false;
    
    private var symbols = [
    						[
    						 [[10,.6],[10,38.8]],
    						 [[21.1,0],[19.9,3.7],[17.5,7.4],[14.4,10.9],[10.7,13.3]],
    						 [[32.4,0],[30,8.2],[25.9,16.3],[18.6,24.1],[10,29.5]]
    						],
    					   	[
    					   	 [[8.7,39.1],[6.7,0.9],[34.3,10.3],[34.3,39.1]]
    					   	],
    					   	[
    					   	 [[17.4,0],[17.6,39.5]],
    					   	 [[17.6,8.5],[30.4,20],[17.1,31.6]]
    					   	],
    					   	[
    					   	 []
    					   	]
    					  ];

    function initialize() {
        WatchFace.initialize();
        
    }
    
    function transformSymbol(index, positionX, positionY, scale, rotation){
    	var symbol = symbols[index];
        for(var l = 0; l < symbol.size(); l += 1){
        	var line = symbol[l];
        	for(var p = 0; p < line.size(); p++){
	        	var point = line[p];
	        	point[0] *= scale;
	        	point[1] *= scale;
        		point[0] += positionX;
        		point[1] += positionY;
        		var x = point[0];
        		var y = point[1];
        		point[0] = Math.cos(rotation)*x - Math.sin(rotation)*y;
        		point[1] = Math.sin(rotation)*x + Math.cos(rotation)*y;
        	}
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
    	if(!symbolsInitiallized){
	        center = dc.getWidth()/2;
	        for(var i = 0; i < 3; i++){
	        	var symbolScale = 1.3;
	        	var symbolSize = 40*symbolScale;
	        	var symbolCenterRadius = center - symbolSize/2;
	        	var symbolOriginX = -symbolSize/2;
	        	var symbolOriginY = -symbolCenterRadius - symbolSize/2;
	        	var rotation = 3.141*2 * (1.0*i/12.0);
	        	transformSymbol(i,symbolOriginX,symbolOriginY,symbolScale,rotation);
	        }
    		symbolsInitiallized = true;
    	}
    
    
    	if(dc has :setAntiAlias) {
        	dc.setAntiAlias(true);
    	}
    	
    	updateWatchOverlay(dc);
    }

	private function drawSymbol(dc as Dc, symbolindex, positionX, positionY) as Void{
		
        var symbol = symbols[symbolindex];
        
        for(var l = 0; l < symbol.size(); l += 1){
        	var line = symbol[l];
        	
        	for(var p = 1; p < line.size(); p++){
	        	var start =	line[p-1];
	        	var end = line[p];
	        	dc.drawLine(start[0]+positionX, start[1]+positionY,
	        				  end[0]+positionX,   end[1]+positionY);
        	}
        }
	}
	
    private function updateWatchOverlay(dc as Dc) as Void {
    	
    	var primaryColor = 0xFFD14D;
    	var secondaryColor = 0x3D3D3D;
        
        
        dc.setColor(Graphics.COLOR_TRANSPARENT, 0x000000);
        dc.clear();
        
        
    	dc.setColor(secondaryColor, 0x000000);
        
        var filldirection = true;
        var pwidth = 2;
        dc.setPenWidth(pwidth);
        dc.drawArc(center, center, center-pwidth/2, filldirection, 0, 360);
        dc.drawArc(center, center, 155, filldirection, 0, 360);
        
    	dc.setColor(primaryColor, 0x000000);
        drawSymbol(dc, 0, center, center);
        drawSymbol(dc, 1, center, center);
        drawSymbol(dc, 2, center, center);
    }
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
