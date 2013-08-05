/**
 * 选项卡组件封装父类
 * code by xiaolb  2011-4-20
 * */


package com.identity
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.YDConfig;
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	public class CLDTabsBase extends CLDBaseComponent
	{
	
		public  var dataArray:Array=[];
		public var  loaderr:BulkLoader;	
		protected var loader:URLLoader;
		public var tabImgArr:Array=new Array();
		public var cldTabs:CLDTabs;
	    public var titleHeight:int;//标题高度
	    public var title:String;

	    public     var _x:int=0;
	    public  var _y:int=0;
	    public var cw:Number;
        public var totalWidth:int=0;
        
        //皮肤位图变量
        private  var bit_leftblue:Bitmap;
        private  var bit_centerdark:Bitmap;
        private  var bit_rightdark:Bitmap;
        private  var bit_centerblue:Bitmap;
        private  var bit_bule:Bitmap;
        private var bit_rightblue:Bitmap;
        private var bit_leftdark:Bitmap;
        
        public var ImgLeftArray:Array=new Array(2);
        public var ImgRightArray:Array=new Array(2);
        
        public var ImgBlueleftArr:Array=new Array(2);
        public var ImgBlueRightArr:Array=new Array(2);
        
        public var ImgBuleArr:Array=new Array();
        public var location:String;
        public var bit:Bitmap;
        private var bitlist:Array=new Array(6);
        
        private var ifused:Boolean=false;
		public function CLDTabsBase()
		{
	
		}
		override protected function addChildren():void
		{

		}  

		   //加载组件数据
	   public function LoadTitleData():void
		   {  	
	            _x=0;
			    _y=0;
		   	//这里要改变加载数据的方式了 ：

			//组建 left 图  黑色
		ImgLeftArray[0]=YDConfig.instance().getBitmap("leftdark1");
		ImgLeftArray[1]=YDConfig.instance().getBitmap("center1");
		ImgLeftArray[2]=YDConfig.instance().getBitmap("centerdark");
		//组建右图    黑色
		ImgRightArray[0]=YDConfig.instance().getBitmap("centerdark");
		ImgRightArray[1]=YDConfig.instance().getBitmap("center1");
		ImgRightArray[2]=YDConfig.instance().getBitmap("darkright1");
		
		//组建蓝色左图
		ImgBlueleftArr[0]=YDConfig.instance().getBitmap("leftbule");
		ImgBlueleftArr[1]=YDConfig.instance().getBitmap("centerbule1");
		ImgBlueleftArr[2]=YDConfig.instance().getBitmap("centerblue");
		
		//组建蓝色右图
		ImgBlueRightArr[0]=YDConfig.instance().getBitmap("centerblue");
		ImgBlueRightArr[1]=YDConfig.instance().getBitmap("centerbule1");
		ImgBlueRightArr[2]=YDConfig.instance().getBitmap("rightbule");
		//组建一个完整的蓝色图
		
		ImgBuleArr[0]=YDConfig.instance().getBitmap("leftbule");
		ImgBuleArr[1]=YDConfig.instance().getBitmap("centerblue");
		ImgBuleArr[2]=YDConfig.instance().getBitmap("rightbule");
 
					 for (var i:int =0;i<dataArray.length;i++)
					 {
					 	if(dataArray.length>1)
					 	{
							 	var ifused:Boolean=false;
							 	var type:int=0;
							 	if(i==0){
							 		    //默认显示一个TAB	 
							 		ifused=true;
							 		bitlist[0]=ImgLeftArray[0];
							 		bitlist[1]=ImgLeftArray[2];
							 		bitlist[2]=ImgLeftArray[1];
							 		bitlist[3]=ImgBlueleftArr[0];
							 		bitlist[4]=ImgBlueleftArr[2];
							 		bitlist[5]=ImgBlueleftArr[1];					 	   
				             
							 	}
							 	if(i==dataArray.length-1){
							 	  type=2;
							 	  bitlist[0]=ImgRightArray[0];
							 	  bitlist[1]=ImgRightArray[2];
							 	  bitlist[2]=ImgRightArray[1];
							 	  bitlist[3]=ImgBlueRightArr[0];
							 	  bitlist[4]=ImgBlueRightArr[2];
							 	  bitlist[5]=ImgBlueRightArr[1];
							 	  
							 	}if(i>0&&i<dataArray.length-1){
							 	  type=1;
							 	  bitlist[0]=ImgLeftArray[2];
							 	  bitlist[1]=ImgLeftArray[2];
							 	  bitlist[2]=ImgLeftArray[2];
							 	  bitlist[3]=ImgBlueleftArr[2];
							 	  bitlist[4]=ImgBlueleftArr[2];
							 	  bitlist[5]=ImgBlueleftArr[2];
							 	 					 	  
							 	}
					 	}
					 	else
					 	{
					 	type=4;
					 	ifused=true;
					 	 bitlist[0]=ImgBuleArr[0];
				 	     bitlist[1]=ImgBuleArr[2];
				 	     bitlist[2]=ImgBuleArr[1];
				 	     bitlist[3]=ImgBuleArr[0];
				 	     bitlist[4]=ImgBuleArr[2];
				 	     bitlist[5]=ImgBuleArr[1];
					 	}
				 	  //画标签的方法
		                title=dataArray[i];
		                cldTabs=new CLDTabs(bitlist,28,600,_x,y,title,ifused,type);  
		                cldTabs.addEventListener("titleClick",tabChange);  
		                //标签的宽度
		                cw=cldTabs.width;
		                tabImgArr[i]=cldTabs;           
		                this.addChild(cldTabs);	  
		                _x+=cldTabs._widths;        	     	     		 
					 }
					 totalWidth=dataArray.length*cldTabs.width;   
		   }

  
		   //TABS 标签点击 标签切换
	    public function tabChange(e:Event):void
		   {		   	
			   	  var cldTab:CLDTabs=e.currentTarget as CLDTabs; 			      			   	  
			      for(var k:int=0;k<dataArray.length;k++)
						 {				 	 
					 	var _cldTab:CLDTabs=tabImgArr[k] as CLDTabs;					 	
					 	//确定用户所点击的title对象		
					 			
					 	if(_cldTab==cldTab)
						 	{	
						 	if(k==0)
						 		{
						 		
							 		bitlist[0]=ImgLeftArray[0];
							 		bitlist[1]=ImgLeftArray[2];
							 		bitlist[2]=ImgLeftArray[1];
							 		bitlist[3]=ImgBlueleftArr[0];
							 		bitlist[4]=ImgBlueleftArr[2];
							 		bitlist[5]=ImgBlueleftArr[1];	
							 	
						    	
						        }
						        if(k>0&&k<tabImgArr.length-1)
						        {
						        
						          bitlist[0]=ImgLeftArray[2];
							 	  bitlist[1]=ImgLeftArray[2];
							 	  bitlist[2]=ImgLeftArray[2];
							 	  bitlist[3]=ImgBlueleftArr[2];
							 	  bitlist[4]=ImgBlueleftArr[2];
							 	  bitlist[5]=ImgBlueleftArr[2];
							 						        	
						        }
						        if(k==tabImgArr.length-1)
						        {
						        
						          bitlist[0]=ImgRightArray[0];
							 	  bitlist[1]=ImgRightArray[2];
							 	  bitlist[2]=ImgRightArray[1];
							 	  bitlist[3]=ImgBlueRightArr[0];
							 	  bitlist[4]=ImgBlueRightArr[2];
							 	  bitlist[5]=ImgBlueleftArr[2];
							
		        
						        }
						         ifused=true;
						         _cldTab.setUsed() ; 
						        _cldTab.drawIMG();						  
						  }
						  
					
						  else{
		 	 	    
		 	 	     	//填充黑色标签
						 	if(k==0)
						 		{					 			
						 		    bitlist[0]=ImgLeftArray[0];
							 		bitlist[0]=ImgLeftArray[0];
							 		bitlist[1]=ImgLeftArray[2];
							 		bitlist[2]=ImgLeftArray[1];
							 		bitlist[3]=ImgBlueleftArr[0];
							 		bitlist[4]=ImgBlueleftArr[2];
							 		bitlist[5]=ImgBlueleftArr[1];	

						        }
						        if(k>0&&k<tabImgArr.length-1)
						        {						        	
						          bitlist[0]=ImgLeftArray[2];
							 	  bitlist[1]=ImgLeftArray[2];
							 	  bitlist[2]=ImgLeftArray[2];
							 	  bitlist[3]=ImgBlueleftArr[2];
							 	  bitlist[4]=ImgBlueleftArr[2];
							 	  bitlist[5]=ImgBlueleftArr[2];				        	
						        }
						        if(k==tabImgArr.length-1)
						        {
						        
						          bitlist[0]=ImgRightArray[0];
							 	  bitlist[1]=ImgRightArray[2];
							 	  bitlist[2]=ImgRightArray[1];
							 	  bitlist[3]=ImgBlueRightArr[0];
							 	  bitlist[4]=ImgBlueRightArr[2];
							 	  bitlist[5]=ImgBlueleftArr[2];				        	
						        }	
						 ifused=false;     	
		 	 	        _cldTab.setNoUsed(); 
		 	 	        _cldTab.drawIMG(); //当前点击的窗体非之前激活的标签时候将之前激活的标签设置为未激活状态
		 	 	        }					
					 
					 }	   	  
		   }
		   //设置组件的数据
		override public function set data(value:*):void
		{
			super.data=value;
			pauseData(value);
		
		}
		private function pauseData(value:String):void
		{
			pauseTabsTitle(value);
		}
		//解析字符串获得TIELE
		private function pauseTabsTitle(value:String):void
		{			
			var tabs:Array=value.split("|");	
			for (var i:int=0; i < tabs.length; i++)
			{
				var contentN:String=tabs[i];	
				if(contentN)		
				{
					var contents:Array=contentN.split("#");
					var title:String=contents[0];				
				      if(title!="")
				      {
						dataArray.push(title);
				      }		
											
			    }
			}
			//得到组件的动态标题
			LoadTitleData();       
      }

	}
}
	