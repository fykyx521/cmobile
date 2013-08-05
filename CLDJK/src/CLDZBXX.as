package
{
	import com.careland.CLDZB;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDFontBase;
	import com.careland.component.render.CLDZBPhotoInfo;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDZBXX extends CLDBaseComponent
	{
		[Embed(source="assets/heng.png")]
		private var heng:Class;
		private var bit:Bitmap;
		
		[Embed(source="assets/shu.png")]   
		private var xiaoshuCls:Class;
		private var xiaoshuBit:Bitmap;
		public function CLDZBXX()
		{
			super();
			
		}
		
		private var photo1:CLDZBPhotoInfo;
		private var photo2:CLDZBPhotoInfo;
		private var photo3:CLDZBPhotoInfo;
		private var photo4:CLDZBPhotoInfo;
		
		var first:Number=455;
		var center:Number=450;
		override protected function addChildren():void
		{
			 bit=new heng as Bitmap;
			 xiaoshuBit=new xiaoshuCls as Bitmap;
			 
			 photo1=new CLDZBPhotoInfo();
			 photo2=new CLDZBPhotoInfo();
			 photo3=new CLDZBPhotoInfo();
			 photo4=new CLDZBPhotoInfo();
			 
			 this.addChild(photo1);
			 this.addChild(photo2);
			 this.addChild(photo3);
			 this.addChild(photo4);
			 
			 photo2.x=first;
			 photo3.x=first+center;
			 photo4.x=first+center*2;
			 
			 
			 title=new TextField();
			 title.selectable=false;
			 title.multiline=false;
			 //title.embedFonts=true;
			 title.defaultTextFormat=new TextFormat("msyh",30,0x00446a);
			 
			 this.addChild(title);
			 
			 qita=new TextField();
			 qita.selectable=false;
			 qita.multiline=true;
			 qita.wordWrap=true;
			 //qita.embedFonts=true;
			 qita.defaultTextFormat=new TextFormat("msyh",30,0x00446a);
			 
			 this.addChild(qita);
		}
		private var txt:CLDZB;
		//var data:String="预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容2:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容3:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n预警内容1:事件描述横向字符数控制为不换行，超出部分点击弹出框显示\n"
		private var title:TextField;
		
		private var qita:TextField;  
		
		override public function draw():void
		{
			if(bit)
			{
				var bottom:Number=125;
				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(3,0x332233,1);
				g.lineBitmapStyle(this.xiaoshuBit.bitmapData);
				g.moveTo(first,0);
				g.lineTo(first,this.height-bottom);
				
				g.moveTo(first+center,0);
				g.lineTo(first+center,this.height-bottom);
				
				g.moveTo(first+center+center,0);
				g.lineTo(first+center+center,this.height-bottom);
				
				g.lineStyle(3,0x332233,1);
				g.lineBitmapStyle(this.bit.bitmapData);
				g.moveTo(0,this.height-bottom);
				g.lineTo(this.width,this.height-bottom);
				g.endFill();
			}
			if(data&&this.dataChange)
			{
				   var date:Date=new Date();
				   var dataXML=XML(data);
				   var xml:XML=null;
				   if(dataXML.data.length()>0)
				   {
					   xml=dataXML.data[0];
				   }
				   
				  // title.text="值班信息:"+date.getFullYear()+"年"+(date.getMonth()+1)+"月"+date.getDate()+"日<font color='#f45d02'>"+xml.@班次+"</font>班<font color='#f45d02'>"+xml.@开始时间+"</font>" ;//+
				   title.text="值班信息:"+date.getFullYear()+"年"+(date.getMonth()+1)+"月"+date.getDate()+"日"+xml.@班次+"班"+xml.@开始时间+"" ;//+
				   //+"<span color='f45d02'>"+xml.@班次+"</span>"；
				   title.y=-50;
				   title.x=(this.width-title.textWidth)/2;
				   title.width=title.textWidth+5;
				   
				   qita.x=5;
				   qita.y=this.height-95;
				   qita.width=this.width-10;
				   qita.height=125;
				 
				   var data1=new Object();
				   var data2=new Object();
				   var data3=new Object();
				   var data4=new Object();
				   
				  var datas:XMLList=dataXML.data;
				  if(datas.length()>0)
				  {
					  var xml=datas[0];
					  data1.gw=String(xml.@岗位资格);
					  data1.gwzz=String(xml.@岗位职责);
					  data1.name=String(xml.@姓名);
					  data1.url=String(xml.@相片);
				  }
				  
				  if(datas.length()>1)
				  {
					  var xml=datas[1];
					  data2.gw=String(xml.@岗位资格);
					  data2.gwzz=String(xml.@岗位职责);
					  data2.name=String(xml.@姓名);
					  data2.url=String(xml.@相片);
				  }
				  
				  if(datas.length()>2)
				  {
					  var xml=datas[2];
					  data3.gw=String(xml.@岗位资格);
					  data3.gwzz=String(xml.@岗位职责);
					  data3.name=String(xml.@姓名);
					  data3.url=String(xml.@相片);
				  }
				  if(datas.length()>3)
				  {
					  var xml=datas[3];
					  data4.gw=String(xml.@岗位资格);
					  data4.gwzz=String(xml.@岗位职责);
					  data4.name=String(xml.@姓名);
					  data4.url=String(xml.@相片);
				  }
				  if(datas.length()>4)
				  {
					  qita.text="";//xml.@备注;
					  var xt:String="";
					  for(var i=4;i<datas.length();i++)
					  {
						  var xml=datas[i];
						 xt+=xml.@姓名+"("+xml.@岗位资格+"）  "
					  }
					  qita.text=xt;
				  }
					 
					 
//					 data2.gw=String(xml.@岗位2);
//					 data2.gwzz=String(xml.@岗位职责2);
//					 data2.name=String(xml.@姓名2);
//					 data2.url=String(xml.@相片2);
//					 
//					 data3.gw=String(xml.@岗位3);
//					 data3.gwzz=String(xml.@岗位职责3);
//					 data3.name=String(xml.@姓名3);
//					 data3.url=String(xml.@相片3);
//					 
//					 data4.gw=String(xml.@岗位4);
//					 data4.gwzz=String(xml.@岗位职责4);
//					 data4.name=String(xml.@姓名4);
//					 data4.url=String(xml.@相片4);
				 
				    photo1.data=data1;
				    photo2.data=data2;
				    photo3.data=data3;
				    photo4.data=data4;
				  
					photo1.width=photo2.width=photo3.width=photo4.width=this.first;
//				   [岗位1]
//				   ,[岗位职责1]
//				   ,[姓名1]
//				   ,[相片1]
//				   ,[岗位2]
//				   ,[岗位职责2]
//				   ,[姓名2]
//				   ,[相片2]
//				   ,[岗位3]
//				   ,[岗位职责3]
//				   ,[姓名3]
//				   ,[相片3]
//				   ,[岗位4]
//				   ,[岗位职责4]
//				   ,[姓名4]
//				   ,[相片4]
//				   ,[状态]
//				   ,[备注]
			   this._dataChange=false;
					   
			}
			 

			 
		}
		
		
	}
}