package com.identity.map
{
	import com.careland.*;
	import com.careland.component.CLDBaseComponent;
	import com.identity.*;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	public class CLDColorManage extends CLDBaseComponent
	{
		private var color1:int=0x7B2904;
		private var color2:int=0xBFBF00;
		private var color3:int=0x00D700;
		private var range:String;
		private var colorWidth:Number;
		public var colorName:String;
        private var ranges:Array;
		private var colors1:Array;
		private var colors2:Array;
		public var text:String;
		private var colorArray:Array=[];
		public function CLDColorManage(_range:String,_width:Number)
		{
			this.range=_range;		
			this.colorWidth=_width;	 
			build();		
		}
		override protected function addChildren():void
		{
		 		  	
		}
		override public function dispose():void{
		    this.color1=null;
		    this.color2=null;
		    this.color3=null;
		    this.range=null;
		    this.colorWidth=null;
		    this.colorName=null;
		    this.ranges=null;
		    this.colors1=null;
		    this.colors2=null;
		}
	    override public function draw():void
		{
		}
		public function checkColor(_range:Number):int{
			var color:int;
		      for(var i:int=0;i<ranges.length;i++){		      	 
		      	 if(_range>=ranges[i]){		      	 	 
		      	 	 	color=colorArray[i];		      	 	 
		      	 	 break;
		      	 }		      	 
		      }
		     
		      if(color==0){
		      	  color=colorArray[ranges.length-1]
		      }
		    return color;
		}
	    private function build():void{
	    	
	      if(this.range!=""){
	      	ranges=range.split(",");
	      	var len:int=0;
	       
	      	if(ranges.length%2==0){
	      		len=ranges.length/2 ;
	      	}else{
	      	    len=ranges.length/2 +1;
	      	}
	       colors1 =ColorGradient.generateTransitionalColor(color1,color2,len);
	       colors2=ColorGradient.generateTransitionalColor(color2,color3,ranges.length-len+1);
	      	var _x:int;
	      	var col:int;
	      	var index:int;
	      	for(var i:int=0;i<colors1.length;i++){
	      		col=colors1[i];
	      	    graphics.beginFill(col,0.5);
	      	    graphics.drawRect(_x,0,colorWidth,15);
	      	    graphics.endFill();	  
	      	    colorArray.push(col);    	   
	      	    _x+=colorWidth;	      	  
	      	}
	      	index=colors1.length;	       
	        for( i=1;i<colors2.length;i++){
	      		col=colors2[i];
	      	    graphics.beginFill(col,0.5);
	      	    graphics.drawRect(_x,0,colorWidth,15);
	      	    graphics.endFill();
	      	    _x+=colorWidth;
	      	    colorArray.push(col); 
	      	}
	      	_x=0;
	      	for(i=0;i<ranges.length;i++){
	      		var text:TextField=new TextField();
	      		 var tf:TextFormat=new TextFormat();
		           tf.size=10;	    
		         //tf.font="msyh";
		           tf.color=0x000000;	
		           text.selectable=false;
		           text.defaultTextFormat=tf;
	      		   text.text=ranges[i];
	      		   text.width=colorWidth;
	      		   text.height=15;
	      		   text.x=_x;
	      		   this.addChild(text);
	      		   _x+=colorWidth;   	      	     
	      	}
	      }
	    }

	}
}