package com.touchlib {
	
import flash.display.*;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.XMLSocket;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Timer;

	public class TUIO
	{
		public static var FLOSCSocket:XMLSocket;		
		static var FLOSCSocketHost:String;			   
		static var FLOSCSocketPort:Number;	
		static var thestage:Stage;
		//---denghuaqin--------------
		static var SubDisplayContainer:DisplayObjectContainer;
		static var sokectTimer:Timer;
		static var Host:String;
		static var Port:Number;
		//---------------------------------------
		static var objectArray:Array;
				
		public static var debugMode:Boolean;		
		
		static var debugText:TextField;
		static var debugToggle:TextField;
		static var recordedXML:XML;
		static var bRecording:Boolean = false;
		//static var xmlPlaybackURL:String = "www/xml/test.xml"; 
		static var xmlPlaybackURL:String = ""; 
		static var xmlPlaybackLoader:URLLoader;
		static var playbackXML:XML;
			
		static var bInitialized = false;
		
	
		public static function init (s:DisplayObjectContainer, host:String, port:Number, debugXMLFile:String, dbug:Boolean = true):void
		{
			if(bInitialized)
				return;
			Host=host;
			Port=port;	
			debugMode = dbug;
			FLOSCSocketHost=host;			
			FLOSCSocketPort=port;			
			bInitialized = true;
			thestage = s.stage;
			//-------------denghuaqin------------------
			SubDisplayContainer=s;
			sokectTimer=new Timer(1000);
			sokectTimer.addEventListener(TimerEvent.TIMER,timerhandle);
			//sokectTimer.start();
			//-------------denghuaqin------------------

			try{
				thestage.align = StageAlign.TOP_LEFT;
				thestage.scaleMode=StageScaleMode.NO_SCALE;	
				//thestage.scaleMode=StageScaleMode.NO_BORDER ;	
				//thestage.scaleMode=StageScaleMode.SHOW_ALL;	
				//thestage.displayState = StageDisplayState.FULL_SCREEN;
				//thestage.scaleMode=StageScaleMode.EXACT_FIT;				
				thestage.displayState = StageDisplayState.FULL_SCREEN;	
				//thestage.scaleMode="noScale";
			}catch(e:Error){				
			}					
			
			objectArray = new Array();
			try
			{
				FLOSCSocket = new XMLSocket();	
				FLOSCSocket.addEventListener(Event.CLOSE, closeHandler);
				FLOSCSocket.addEventListener(Event.CONNECT, connectHandler);
				FLOSCSocket.addEventListener(DataEvent.DATA, dataHandler);
				FLOSCSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				FLOSCSocket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				FLOSCSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);	
				FLOSCSocket.connect(host, port);			
			
			}catch(e:TypeError)
			{
			}
			
			if(debugMode)
			{
				var format:TextFormat = new TextFormat();
				debugText = new TextField();
       			format.font = "Verdana";
     			format.color = 0xFFFFFF; 
        		format.size = 10;
        
				debugText.defaultTextFormat = format;
				debugText.autoSize = TextFieldAutoSize.LEFT;
				debugText.background = true;	
				debugText.backgroundColor = 0x000000;	
				debugText.border = true;	
				debugText.borderColor = 0x333333;	
				thestage.addChild( debugText );
					
				thestage.setChildIndex(debugText, thestage.numChildren-1);	
		
				recordedXML = <OSCPackets></OSCPackets>;	

				 if(xmlPlaybackURL != "")  
				 {
					xmlPlaybackLoader = new URLLoader();
					xmlPlaybackLoader.addEventListener("complete", xmlPlaybackLoaded);
					xmlPlaybackLoader.load(new URLRequest(xmlPlaybackURL));
			
					thestage.addEventListener(Event.ENTER_FRAME, frameUpdate);
				 }
				
			} else {
				recordedXML = <OSCPackets></OSCPackets>;
				bRecording = false;
			}
			trace("tuio.inited:");
			trace(SubDisplayContainer.width * SubDisplayContainer.scaleX);
			trace(SubDisplayContainer.height*SubDisplayContainer.scaleY);

			
		}
		private static function timerhandle(evt:TimerEvent) {
			FLOSCSocket.connect(Host, Port);	
		}
		private static function xmlPlaybackLoaded(evt:Event) {
			trace("Loaded xml debug data");
			playbackXML = new XML(xmlPlaybackLoader.data);
		}
		
		private static function frameUpdate(evt:Event)
		{
			if(playbackXML && playbackXML.OSCPACKET && playbackXML.OSCPACKET[0])
			{
				if (Port==3030)
					processMessage_new(playbackXML.OSCPACKET[0]);
				else 
					processMessage(playbackXML.OSCPACKET[0]);
					

				delete playbackXML.OSCPACKET[0];
			}
		}		
		
		public static function getObjectById(id:Number): TUIOObject
		{
			if (objectArray==null) return null; //add by denghuaqin
			for(var i=0; i<objectArray.length; i++)
			{
				if(objectArray[i].ID == id)
				{
					//trace("found " + id);
					return objectArray[i];
				}
			}
			//trace("Notfound");
			
			return null;
		}
		
		public static function listenForObject(id:Number, reciever:Object)
		{
			var tmpObj:TUIOObject = getObjectById(id);
			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}

		}
		public static function processMessage(msg:XML)
		{

			var fseq:String;
			var node:XML;
			//.var flag:Boolean;
			//.flag=true;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "fseq")
					fseq = node.ARGUMENT[1].@VALUE;	
				//.if (fseq=="-1") 
					//.flag=false;
				//.else
					//.flag=true;
			}
///			trace("fseq = " + fseq);

			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (var obj1:TUIOObject in objectArray)
					{
						obj1.isAlive = false;
					}
					//.var flag1:Boolean;
					//.flag1=true;
					var newIdArray:Array = new Array();					
					for each(var aliveItem:XML in node.ARGUMENT.(@VALUE != "alive"))
					{
						if(getObjectById(aliveItem.@VALUE))
							getObjectById(aliveItem.@VALUE).isAlive = true;
						//.flag1=false;

					}   
					//.if (!flag && flag1) 
					//.for each (var obj1:TUIOObject in objectArray)
					//.{
						//.obj1.isAlive = true;
					//.}
					//trace(idArray);

					//idArray = newIdArray;
				}

			}			
			
							
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0])
				{
					var type:String;
					
					if(node.@NAME == "/tuio/2Dobj")
					{
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var sID = node.ARGUMENT[1].@VALUE;
							var id = node.ARGUMENT[2].@VALUE;
							var x = Number(node.ARGUMENT[3].@VALUE) * thestage.stageWidth;
							var y = Number(node.ARGUMENT[4].@VALUE) * thestage.stageHeight;
							var a = Number(node.ARGUMENT[5].@VALUE);
							var X = Number(node.ARGUMENT[6].@VALUE);
							var Y = Number(node.ARGUMENT[7].@VALUE);
							var A = Number(node.ARGUMENT[8].@VALUE);
							var m = node.ARGUMENT[9].@VALUE;
							var r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							var objArray:Array = thestage.getObjectsUnderPoint(new Point(x, y));
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);							
							var dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							
						
							var tuioobj:TUIOObject = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y,1,1, X, Y, sID, a, dobj);
											//TUIOObject("2Dcur", id, x, y,w,h, X, Y, -1, a, dobj);
								thestage.addChild(tuioobj.spr);
								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();								
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.dX = X;
								tuioobj.dY = Y;

								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();								
							}
							
							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e:Error)
							{
							}

		
						}
						
					} else if(node.@NAME == "/tuio/2Dcur")
					{
//						trace("2dcur");
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var id = node.ARGUMENT[1].@VALUE;
							var x = Number(node.ARGUMENT[2].@VALUE) * thestage.stageWidth;
							var y = Number(node.ARGUMENT[3].@VALUE) *  thestage.stageHeight;
							var X = Number(node.ARGUMENT[4].@VALUE);
							var Y = Number(node.ARGUMENT[5].@VALUE);
							var m = node.ARGUMENT[6].@VALUE;
							//-------new features -------add width and height property 
							var blobWidth:Number=1;
							var blobHeight:Number=1;
							if (node.ARGUMENT.length()>7)
							{
								blobWidth = Number(node.ARGUMENT[7].@VALUE * thestage.stageWidth);
								blobHeight = Number(node.ARGUMENT[8].@VALUE* thestage.stageHeight);
							}
							//----------------------------------------------------------------
							
							//var area = node.ARGUMENT[7].@VALUE;							
							
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);
							var dobj = null;
							if(displayObjArray.length > 0)								
								dobj = displayObjArray[displayObjArray.length-1];							
														
								
							var sztmp:String="";
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y,blobWidth,blobHeight, X, Y, sID, a, dobj);
								//tuioobj.area = area;
								thestage.addChild(tuioobj.spr);								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;
								tuioobj.x = x;
								tuioobj.y = y;
								//tuioobj.area = area;								
								tuioobj.dX = X;
								tuioobj.dY = Y;
								tuioobj.ObjectWidth = blobWidth;
								tuioobj.ObjectHeight = blobHeight;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();
							}  

							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a,blobWidth,blobHeight));
								}
							} catch (e)
							{
								trace("Dispatch event failed " + tuioobj);
							}

	
						}
					}
				}
			}
			

			if(debugMode)
			{
				debugText.text = "";
				debugText.y = -2000;
				debugText.x = -2000;	
			}	
			for (var i=0; i<objectArray.length; i++ )
			{
				if(objectArray[i].isAlive == false)
				
				{
					objectArray[i].kill();
					thestage.removeChild(objectArray[i].spr);
					objectArray.splice(i, 1);
					i--;

				} else {
					if(debugMode)
					{
//						debugText.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) + "  \n");
//						debugText.x = thestage.stageWidth-160;
//						debugText.y = 40;		
					}
					}
			}
		}

		public static function processMessage_new(msg:XML)
		{
			//trace("processMessage:");
			//trace(SubDisplayContainer.width*SubDisplayContainer.scaleX);
			//trace(SubDisplayContainer.height*SubDisplayContainer.scaleY);
			//trace(SubDisplayContainer.scaleX);
			//trace(SubDisplayContainer.scaleY);		
			for each (var obj1:TUIOObject in objectArray)
			{
				obj1.isAlive = false;
			}	
			
			var node:XML;
		////////-----------limit two Point -test-----------------------
			//var tempNum:int=0;
			//for each(node in msg.set) tempNum++;
			//if (tempNum>2) return;
		/////////////-------------------------------------	 
			for each(node in msg.set)
			{
				//更新alive  表示该点是否存在的信息  
				//trace("entered");
				if (getObjectById(node.@id))
				{
					getObjectById(node.@id).isAlive=true;		
				}  		
				
				var sID:int=0;
				var id = node.@id;
				 
				//"<set id=\"%d\" x=\"%f\" y=\"%f\" a=\"%f\" w=\"%f\" h=\"%f\" dx=\"%f\" dy=\"%f\"/>",
	
				var x = Number(node.@x) * thestage.stageWidth;
				var y = Number(node.@y) * thestage.stageHeight;		
									
				var a= Number(node.@a);
				var w= Number(node.@w)* thestage.stageWidth;
				var h= Number(node.@h)* thestage.stageHeight;

				var X = Number(node.@dx);
				var Y = Number(node.@dy);	
				var m = Number(node.@m);
					
				// send object update event..
				var stagePoint:Point = new Point(x,y);					
				var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);
				var dobj = null;
				
				if(displayObjArray.length > 0)								
					dobj = displayObjArray[displayObjArray.length-1];				

				var tuioobj = getObjectById(id);
				if(tuioobj == null)
				{
					tuioobj = new TUIOObject("2Dcur", id, x, y,w,h, X, Y, -1, a, dobj);
					tuioobj.ObjectWidth=w;
					tuioobj.ObjectHeight=h;
					//tuioobj.area = area;
					thestage.addChild(tuioobj.spr);								
					objectArray.push(tuioobj);
					tuioobj.notifyCreated();
				} else {
					tuioobj.spr.x = x;
					tuioobj.spr.y = y;
					//tuioobj.oldX=tuioobj.x;
					//tuioobj.oldY=tuioobj.y;
					//new TUIOObject()
					tuioobj.x = x;
					tuioobj.y = y;
					//tuioobj.h = h;
					tuioobj.ObjectWidth=w;
					tuioobj.ObjectHeight=h;
					/*
					if (w==0 || h==0) 
					{
						tuioobj.ObjectWidth=6;
						tuioobj.ObjectHeight=6;
					}*/
					tuioobj.angle=a;
					//tuioobj.area = area;								
					tuioobj.dX = X;
					tuioobj.dY = Y;
					
					if  (X!=0||Y!=0)
					{
						tuioobj.setObjOver(dobj);
						tuioobj.notifyMoved();
					}
				}  

				try
				{
					if(tuioobj.obj && tuioobj.obj.parent)
					{							
						var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
						//tuioobj.obj.dispatchEvent(new TUIOEvent(TUIOEvent.TUIO_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
					}
				} catch(e:TypeError)
				{
					trace("Dispatch event failed " + tuioobj.name);
				}		

			}

			if(debugMode)
			{
				debugText.text = "";
				debugText.y = -2000;
				debugText.x = -2000;	
			}	
			
			for (var i=0; i<objectArray.length; i++ )
			{
				if(objectArray[i].isAlive == false)
				
				{
					objectArray[i].kill();
					thestage.removeChild(objectArray[i].spr);
					objectArray.splice(i, 1);
					i--;

				} else {
					if(debugMode)
					{
//						debugText.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) + "  \n");
//						debugText.x = thestage.stageWidth-160;
//						debugText.y = 40;		
					}
					}
			}
		}
		

		
		private static function toggleDebug(e:Event)
		{ 
			if(!debugMode){
			debugMode=true;	
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.x=20;
			}
			else{
			debugMode=false;
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.x=0;
			}
			
			// show XML
			//bRecording = false;
			//debugMode = false;			
			//debugText.text = recordedXML.toString();
			//debugText.x = 0;
			//debugText.y = 0;	
		}
		
        private static function closeHandler(event:Event):void {
            trace("closeHandler: " + event);
            sokectTimer.start();
        }

        private static function connectHandler(event:Event):void {
         	trace("connectHandler: " + event);
         	sokectTimer.stop();
        }

        private static function dataHandler(event:DataEvent):void {
			
           if (event.data==null) 
           		return;
           	//trace("dataHandler: " + event.data);
			
			if(bRecording)
				recordedXML.appendChild( XML(event.data) );
			//trace(event.data);
			//trace(XML(event.data));
			if (Port==3030)
				processMessage_new(XML(event.data));
			else 
				processMessage(XML(event.data));
        }

        private static function ioErrorHandler(event:IOErrorEvent):void {
			sokectTimer.start();	
            trace("ioErrorHandler: " + event);
        }

        private static function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private static function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
//			thestage.tfDebug.appendText("securityError: " + event + "\n");			
        }
	}
}