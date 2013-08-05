package
{
	import com.careland.CLDBase;
	import com.careland.CLDJKState;
	import com.careland.CLDWLYJ;
	import com.careland.CLDYJList;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDFontBase;
	import com.careland.component.render.CLDScrollBar;
	import com.careland.component.render.CLDTextRender;
	import com.identity.jk.CLDYJList;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDJK extends CLDBaseComponent
	{
		var titles:Array=["类型","时间","负责","事件描述","进展","action"];
		
		var datas:Array=[
			{
				类型:"例行工作",
				时间:"20.20",
				负责:"服务岗",
				事件描述:"事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n",
				进展:"已处理"
			},
			{
				类型:"突发工作",
				时间:"20.20",
				负责:"服务岗",
				事件描述:"事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n",
				进展:"已处理"
			},
			{
				类型:"注意事项",
				时间:"20.20",
				负责:"服务岗",
				事件描述:"事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n",
				进展:"已处理"
			}  
			
		];
		public function CLDJK()
		{
			super();
		}
		
	
	 [Embed(source="assets/heng.png")]
	 private var heng:Class;
	 private var bit:Bitmap;
	 
	 [Embed(source="assets/shu.png")]  
	 private var xiaoshuCls:Class;
	 private var xiaoshuBit:Bitmap;
	 
	
	 override public function set data(value:*):void
	 {
		 this.parse(value);
		 super.data=value;
	 }
	 
	 private var columnPreWidth:Array=[];
	 private var ids:Array;
	 private var titleHeight:Number=50;
	 
	 private var truncateIndex:int=2;
	 
	 private var col:Array=[];
	 
	 public var listtiles:Array=[];
	 private var spliceCol:Array=[];
	 
	 private var data0Column:Array=[]
	 private function parse(value:*):void
	 {
		 var data:XML=XML(value);
		 var title:String=data.data[0].@titles;
		 titles=title.split(",");
		 listtiles=title.split(",");
		 listtiles.splice(0,1);
		 
		 var columnWidth:String=data.data[0].@列宽百分比;
		 
		 var cpw:Array=columnWidth.split(",");
		// spliceCol=columnWidth.split(",");
		 for(var i:int=0;i<cpw.length;i++)
		 {
			 col.push(Number(cpw[i]));
			 spliceCol.push(Number(cpw[i]));
		 }
		 spliceCol.splice(0,1);
		 ids=String(data.data[0].@数据ID).split(",");
		 
		 titleHeight=Number(data.data[0].@标题高度);
		 
		 truncateIndex=Number(data.data[0].@超出索引);
		 
		 data0Column=String(data.data[0].@类型).split(",");
		 
		 this.invalidate();
	 }
	 
	 
	 private function addBit(gridHeight:Number,moveTo:Number):void
	 {
		 xiaoshuBit=new xiaoshuCls as Bitmap;
		 var hengx:Bitmap=new Bitmap(this.xiaoshuBit.bitmapData.clone());
		 hengx.x=moveTo;
		 
		 hengx.height=gridHeight;
		 this.addChild(hengx);
	 }
	 override public function draw():void
	 {
		 if(data)
		 {
			 this.dispose();
			 
			 
			
			 var g:Graphics=this.graphics;
			 g.clear();
			 g.lineStyle(1,0x000222,1);
			 //g.lineBitmapStyle(this.xiaoshuBit.bitmapData);
			 var gridHeight:Number=this.height/3;
			 var movoTo:Number=0;
			 
			 var columnRealWidth:Array=[];
			 var columnRealPoint:Array=[0];
			 var columnRealPointTitle:Array=[0];
			 
			 for(var i:int=0;i<col.length;i++)
			 {
				 var singleWidth:Number=col[i];//(this.width*columnPreWidth[i]/100);
				 movoTo+=singleWidth;
				 g.moveTo(movoTo,0);
				 g.lineTo(movoTo,this.height);
				 columnRealWidth.push(singleWidth);//把每一列的宽度 保存起来
				 columnRealPoint.push(movoTo-col[0]);  
				 columnRealPointTitle.push(movoTo);  
				   
				 addBit(this.height,movoTo);
			 }
			 for(var j:int=0;j<col.length;j++)
			 {
				 var txt:TextField=new TextField();
				 txt.selectable=false;
				 txt.multiline=false;
				 txt.wordWrap=false;
				// txt.embedFonts=true;
				 txt.defaultTextFormat=new TextFormat("msyh",30,0x00446a);
				 txt.text=this.titles[j];
				 txt.x=(columnRealWidth[j]-txt.textWidth)/2+columnRealPointTitle[j];
			     txt.y=-50;
				 txt.width=txt.textWidth+5;
				 this.addChild(txt);
			 }
			 var typey:Number=0;
			 for(var v:int=0;v<this.data0Column.length;v++)
			 {
				 var txt:TextField=new TextField();
				 txt.selectable=false;
				 txt.multiline=true;
				 txt.wordWrap=true;
				// txt.embedFonts=true;
				 txt.width=30;
				 txt.defaultTextFormat=new TextFormat("msyh",30,0x00446a);
				
				 txt.text=data0Column[v];
				 txt.height=txt.textHeight+5;
				 txt.x=(this.col[0]- txt.width)/2;
				 txt.y=(gridHeight-txt.height)/2+typey;
				 typey+=gridHeight;
				 //txt.width=txt.textWidth+5;
				 this.addChild(txt);
			 }
			 
			 
			 g.endFill();
			 g.clear();
			 
		      bit=new heng as Bitmap;
			 var hengx:Bitmap=new Bitmap(this.bit.bitmapData.clone());
			 hengx.x=0;
			 hengx.y=gridHeight;
			 hengx.width=this.width;
			 this.addChild(hengx);
			 
			 var hengx:Bitmap=new Bitmap(this.bit.bitmapData.clone());
			 hengx.x=0;
			 hengx.y=gridHeight*2;
			 hengx.width=this.width;
			 this.addChild(hengx);
			 
			 
			 var ypos:Number=0;
			 columnRealPoint.splice(1,1);//把第一列的类型去掉
			 for(var z:int=0;z<ids.length;z++)
			 {
				 var list:com.identity.jk.CLDYJList=new com.identity.jk.CLDYJList();
				 list.columnRealPoint=columnRealPoint;
				 list.columnRealWidth=spliceCol;
				 list.height=gridHeight;
				 list.truncateIndex=truncateIndex;
				 list.titles=listtiles;
				 list.width=this.width-col[0]-42;//14 scrollbar的宽度
				 list.infoGap=52+this.col[0];
				 list.x=col[0];
				 list.y=ypos;
				 list.contentID=ids[z];
				 list.autoLoad=true;
				 
				 this.addChild(list);
				 ypos+=gridHeight;
				 
				 //添加类型
			 }
			 
		 }
	 }
	 override public function dispose():void
	 {
		 super.dispose();
		 while(this.numChildren>0)
		 {
			 this.removeChildAt(0);
		 }
	 }

	}
	
	
	 
}
