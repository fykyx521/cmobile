package com.identity.intelSingleNode
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	public class CLDTopo extends Sprite
	{
		var bk:BulkLoader=new BulkLoader("main000");
		public function CLDTopo()
		{
			super();
//			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
//			stage.align=flash.display.StageAlign.TOP_LEFT;
			bk.add("assets/paipai.xml",{id:"xml"});
			bk.start();
			bk.addEventListener(BulkProgressEvent.COMPLETE,complete);
		}
		
		private function complete(e:Event):void{
		
			var g:Graphics=this.graphics;
			var xml:XML=XML(bk.get("xml").content);
			
			var xmllist:XMLList=xml.data;
			for(var i:int=0;i<xmllist.length();i++){
				
				var dataXML:XML=xmllist[i];
				
				var nameID:String=dataXML.@["NameID"];
				var p1s:String=dataXML.@["point1"];
				var p1:Point=new Point(0,0);
				if(p1s){
					var obj=p1s.split(",");
					p1=new Point(obj[0],obj[1]);	
				}
				
				var p2s:String=dataXML.@["point2"];
				var p2:Point=new Point(0,0);
				if(p2s){
					var obj1=p2s.split(",");
					p2=new Point(obj1[0],obj1[1]);	
				}							
				if(nameID.indexOf("Point_",0)!=-1){
					g.beginFill(0x000fff,1);
					
					g.drawCircle(p1.x,p1.y,20);
					g.endFill();
				}
				if(nameID.indexOf("Line_",0)!=-1){
					g.lineStyle(1,0x000fff);
					g.moveTo(p1.x,p1.y);
					g.lineTo(p2.x,p2.y);
					g.endFill();
				}
				
			}	
		}
		
	}
}