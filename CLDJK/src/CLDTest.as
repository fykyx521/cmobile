package
{
	import com.bit101.components.Calendar;
	import com.careland.component.render.CLDTextRender;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class CLDTest extends Sprite
	{
		
		
		[Embed(source="assets/hk/滑块中.png")]
		private var splideCls:Class;
		private var splide:Bitmap;
		
		[Embed(source="assets/heng.png")]
		private var heng:Class;
		private var bit:Bitmap;
		
		[Embed(source="assets/shu.png")]  
		private var xiaoshuCls:Class;
		private var xiaoshuBit:Bitmap;
		
		public function CLDTest()
		{
			super();
			if(stage)
			{
				initObj();
			}else
			{
				
				this.addEventListener(Event.ADDED_TO_STAGE,initObj);
			}
		}
		private var txt:CLDTextRender;
		var data:String="预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容2:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容3:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n"
		
		
		
			
		public function initObj(e:Event=null):void
		{
			 
			this.removeEventListener(Event.ADDED_TO_STAGE,initObj);
			this.stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			this.stage.align=flash.display.StageAlign.TOP_LEFT;
			
			bit=new heng as Bitmap;
			
			var bitn:Bitmap=new Bitmap(bit.bitmapData.clone());
			bitn.y=200;
			bitn.width=300;
			
			this.addChild(bitn);
			
			var bitn1:Bitmap=new Bitmap(bit.bitmapData.clone());
			bitn1.y=300;
			bitn1.width=400;
			
			this.addChild(bitn1);
			
			splide=new splideCls as Bitmap;
			this.addChild(splide);
//			txt=new CLDTextRender();  
//			this.addChild(txt);
//			txt.setSize(500,400);
//			txt.data=data;
//			txt.initEvent();
			
			
			splide.height=200;
			
			var gra:Graphics=this.graphics;
			gra.lineBitmapStyle(bit.bitmapData);
			gra.moveTo(0,0);
			gra.lineTo(100,100);
			gra.endFill();
			
			var care:Calendar=new Calendar();
			care.setDate(new Date);
			this.addChild(care);
			   
		}
	}
}