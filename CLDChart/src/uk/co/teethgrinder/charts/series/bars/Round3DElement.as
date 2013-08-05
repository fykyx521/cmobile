﻿    package uk.co.teethgrinder.charts.series.bars {
       import flash.filters.DropShadowFilter;
       import flash.geom.Matrix;
	   import uk.co.teethgrinder.charts.series.bars.BaseElement;
	   import uk.co.teethgrinder.Properties;
	   import uk.co.teethgrinder.ScreenCoords;
	   import uk.co.teethgrinder.ScreenCoordsBase;
       
       public class Round3DElement extends BaseElement
       {
          
          public function Round3DElement( index:Number, props:Properties, group:Number ) {
             
             super(index, props, group);
             //super(index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
             
             var dropShadow:DropShadowFilter = new flash.filters.DropShadowFilter();
             dropShadow.blurX = 5;
             dropShadow.blurY = 5;
             dropShadow.distance = 3;
             dropShadow.angle = 45;
             dropShadow.quality = 2;
             dropShadow.alpha = 0.4;
             // apply shadow filter
             this.filters = [dropShadow];
          }
          
          public override function resize( sc:ScreenCoordsBase,w:Number,hh:Number):void {
             
             this.graphics.clear();
             var h:Object = this.resize_helper( sc as ScreenCoords );
             
             this.bg( h.width, h.height, h.upside_down );
             this.glass( h.width, h.height, h.upside_down );
          }
          
          private function bg( w:Number, h:Number, upside_down:Boolean ):void {

             var rad:Number = w/3;
             if ( rad > ( w / 2 ) )
                rad = w / 2;
                
             this.graphics.lineStyle(0, 0, 0);// this.outline_colour, 100);
             
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
             
                if (!upside_down && h > 0)
                { /* draw bar upward */
                
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                                        
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, w/2);
                      this.graphics.lineTo(0, h);
                      this.graphics.lineTo(w, h);
                      this.graphics.lineTo(w, w / 2);   
                               
                      /* draw top ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                      
                      /* draw bottom half ellipse */
                      x = w/2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);   
                               
                      /* draw top ellipse */
                      x = w / 2;
                      y = h;
                      xRadius = w / 2;
                      yRadius = h;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                }
                
                else
                
                { /*draw bar downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw top half ellipse */
                      x = w/2;
                      y = 0;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                         
                      /* draw connecting rectangle */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );
                      this.graphics.moveTo(0, 0);
                      this.graphics.lineTo(0, h - w / 2);
                      this.graphics.lineTo(w, h - w / 2);
                      this.graphics.lineTo(w, 0);   
                         
                      /* draw bottom ellipse */
                      //this.graphics.beginFill(this.colour, 1);
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                   
                   }
                   
                   else
                   
                   { /* bar is too short for normal draw */
                   
                      if (h > 0)
                      
                      { /* bar greater than zero */
                      
                         /* draw top half ellipse */
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         halfEllipse(x, y, xRadius, yRadius, 100, true);   
                                  
                         /* draw bottom ellipse */
                         x = w / 2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = h;
                         halfEllipse(x, y, xRadius, yRadius, 100, false);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                      
                         /* draw top ellipse */
                         x = w/2;
                         y = h;
                         xRadius = w / 2;
                         yRadius = rad / 4;
                         Ellipse(x, y, xRadius, yRadius, 100);         
                         
                      }
                      
                   }
                   
                }
             
             this.graphics.endFill();
          }
          
          private function glass( w:Number, h:Number, upside_down:Boolean ): void {
             
             /* if this section is commented out, the white shine overlay will not be drawn */
             
             this.graphics.lineStyle(0, 0, 0);
             var bgcolors:Array = GetColours(this.colour);
             var bgalphas:Array = [1, 1];
             var bgratios:Array = [0, 255];
             var bgmatrix:Matrix = new Matrix();
             
             bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI );
             
             /* set gradient fill */
             var colors:Array = [0xFFFFFF, 0xFFFFFF];
             var alphas:Array = [0, 0.75];
             var ratios:Array = [100,255];         
             var xRadius:Number;
             var yRadius:Number;
             var x:Number;
             var y:Number;
             var matrix:Matrix = new Matrix();
             matrix.createGradientBox(width, height, (180 / 180) * Math.PI );
             this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
             var rad:Number = w / 3;
                
                if (!upside_down && h > 0)
                { /* draw shine upward */
                
                   if (h >= w / 2)
                   { /* bar is tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), w/2);
                      this.graphics.lineTo(0 + (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), h);
                      this.graphics.lineTo(w - (0.05 * w), w/2);   
                               
                            
                      /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                
                      /* draw bottom half ellipse shine */
                      x = w/2;
                      y = h;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);      
                      
                      /* draw top ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = h - 2.5*(0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, true);
                      
                   }
                
                }
                
                else
                
                { /* draw shine downward */
                   
                   if ( h >= w / 2)
                   { /* bar is tall enough for normal draw */
                      
                      /*draw connecting rectangle shine */
                      this.graphics.moveTo(0 + (0.05 * w), 0);
                      this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                      this.graphics.lineTo(w - (0.05 * w), 0);   
                               
                            
                      /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w / 2;
                      y = h - w / 2;
                      xRadius = w / 2;
                      yRadius = xRadius;
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                      
                      /* draw bottom ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w / 3;
                      y = h - w / 2;
                      xRadius = w / 3 - (0.05 * w);
                      yRadius = xRadius + (0.05 * w);
                      halfEllipse(x, y, xRadius, yRadius, 100, false);
                
                      /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                      x = w/2;
                      y = 0;
                      xRadius = w / 2;
                      yRadius = rad / 2;
                      Ellipse(x, y, xRadius, yRadius, 100);
                   
                      /* draw top half ellipse shine */
                      this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.7], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                      x = w/2;
                      y = 0;
                      xRadius = w / 2 - (0.05 * w);
                      yRadius = rad / 2 - (0.05 * w);
                      Ellipse(x, y, xRadius, yRadius, 100);
                   
                   }
                   
                   else
                   
                   { /* bar is not tall enough for normal draw */
                   
                      if (h > 0)
                      { /* bar is greater than zero */
                         
                         /* draw bottom ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, alphas, ratios, matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w / 3;
                         y = 0;
                         xRadius = w / 3 - (0.05 * w);
                         yRadius = h - 2.5*(0.05 * w);
                         halfEllipse(x, y, xRadius, yRadius, 100, false);   
                
                         /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                         /* draw top half ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.67], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                          x = w/2;
                         y = 0;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 2 - (0.05 * w);
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                      }
                      
                      else
                      
                      { /* bar is zero */
                      
                         /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, bgcolors, bgalphas, bgratios, bgmatrix, 'pad'/*SpreadMethod.PAD*/ );            
                         x = w/2;
                         y = 0;
                         xRadius = w / 2;
                         yRadius = rad / 2;
                         Ellipse(x, y, xRadius, yRadius, 100);
                      
                         /* draw top half ellipse shine */
                         this.graphics.beginGradientFill('linear' /*GradientType.Linear*/, colors, [0.1, 0.7], [0,255], matrix, 'pad'/*SpreadMethod.PAD*/ );
                         x = w/2;
                         y = 0;
                         xRadius = w / 2 - (0.05 * w);
                         yRadius = rad / 2 - (0.05 * w);
                         Ellipse(x, y, xRadius, yRadius, 100);
                         
                      }   
                      
                   }
                   
                }
                   
                this.graphics.endFill();
          }
          
          /* function to process colors */
          /* returns a base color and a highlight color for the gradients based on the color passed in */
          public static function GetColours( col:Number ):Array {
             var rgb:Number = col; /* decimal value for color */
             var red:Number = (rgb & 16711680) >> 16; /* extacts the red channel */
             var green:Number = (rgb & 65280) >> 8; /* extacts the green channel */
             var blue:Number = rgb & 255; /* extacts the blue channel */
             var shift:Number = 2; /* shift factor */
             var basecolor:Number = col; /* base color to be returned */
             var highlight:Number = col; /* highlight color to be returned */
             var bgred:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var bggreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var bgblue:Number = rgb & 255; /* blue channel for highlight */
             var hired:Number = (rgb & 16711680) >> 16; /* red channel for highlight */
             var higreen:Number = (rgb & 65280) >> 8; /* green channel for highlight */
             var hiblue:Number = rgb & 255; /* blue channel for highlight */
             
             /* set base color components based on ability to shift lighter */   
             if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255)
             {
                bgred = red - red / shift;
                bggreen = green - green / shift;
                bgblue = blue - blue / shift;
             }            
                
             /* set highlight components based on base colors */   
             hired = bgred + red / shift;
             hiblue = bgblue + blue / shift;
             higreen = bggreen + green / shift;
             
             /* reconstruct base and highlight */
             basecolor = bgred << 16 | bggreen << 8 | bgblue;
             highlight = hired << 16 | higreen << 8 | hiblue;
                      
             /* return base and highlight */
             return [highlight, basecolor];
          }
          
          /* ellipse cos helper function */
          public static function magicTrigFunctionX (pointRatio:Number):Number{
             return Math.cos(pointRatio*2*Math.PI);
          }
          
          /* ellipse sin helper function */
          public static function magicTrigFunctionY (pointRatio:Number):Number{
             return Math.sin(pointRatio*2*Math.PI);
          }
          
          /* ellipse function */
          /* draws an ellipse from passed center coordinates, x and y radii, and number of sides */
          public function Ellipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number):Number{
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=0; i<=sides; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
          /* half ellipse function */
          /* draws half of an ellipse from passed center coordinates, x and y radii, number of sides , and top/bottom */
          public function halfEllipse(centerX:Number, centerY:Number, xRadius:Number, yRadius:Number, sides:Number, top:Boolean):Number{
             
             var loopStart:Number;
             var loopEnd:Number;
             
             if (top == true)
             {
                loopStart = sides / 2;
                loopEnd = sides;
             }
             else
             {
                loopStart = 0;
                loopEnd = sides / 2;            
             }
             
             /* move to first point on ellipse */
             this.graphics.moveTo(centerX + xRadius,  centerY);
             
             /* loop through sides and draw curves */
             for(var i:Number=loopStart; i<=loopEnd; i++){
                var pointRatio:Number = i/sides;
                var xSteps:Number = magicTrigFunctionX(pointRatio);
                var ySteps:Number = magicTrigFunctionY(pointRatio);
                var pointX:Number = centerX + xSteps * xRadius;
                var pointY:Number = centerY + ySteps * yRadius;
                this.graphics.lineTo(pointX, pointY);
             }
             
             /* return 1 */
             return 1;
          }
          
       }
    }