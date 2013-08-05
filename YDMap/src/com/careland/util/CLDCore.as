package com.careland.util
{
	import flash.geom.Point;

	public class CLDCore
	{
		public static var config:CLDConfig=CLDConfig.instance();
		public function CLDCore()
		{
			
		}
		public static function setMoveUpdate(offSetX, offSetY,mapW,mapH,mapConfig:MapConfig,center:Point) {
			//处理超出范围
			var offsetArray = CLDCore.getOffsetMapXY(offSetX, offSetY,mapConfig,mapW,mapH,center); 
			offSetX = offsetArray[0];
			offSetY = offsetArray[1];
			var newcenterX = 0;
			var newcenterY = 0;
			var tilemapindex=mapConfig.tilemapindex;
			if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
				//lijian coord
				newcenterX = ((center.x) - offSetX * mapConfig.wscale);
				newcenterY = ((center.y) + offSetY * mapConfig.hscale);
			}
			else if(tilemapindex == 2 || tilemapindex == 8){
				var pixC = config.pointToPixel_3D_1(center.x, center.y, mapConfig.scale);
				var newC = config.pixelToPoint_3D_1((pixC.x-offSetX), (pixC.y-offSetY), mapConfig.scale);
				
				newcenterX = newC.x;
				newcenterY = newC.y;
			}
			else if(tilemapindex == 5 || tilemapindex == 6){
				var pixC = config.pointToPixel_3D_2(center.x, center.y, mapConfig.scale);
				var newC = config.pixelToPoint_3D_2((pixC.x-offSetX), (pixC.y-offSetY), mapConfig.scale);
				
				newcenterX = newC.x;
				newcenterY = newC.y;
			}
			else if(tilemapindex == 7){
				//获取放缩中心点在新level上的pixelCoords坐标
				var pixelCenter = config.converterM2P({Mx:center.x, My:center.y}, mapConfig.scale);
				//获取新视图的中心点在新level上的pixelCoords坐标
				pixelCenter = {Px:(pixelCenter.Px - offSetX), Py:(pixelCenter.Py - offSetY)};
				//获取新视图的中心点在MapCoords坐标系中的坐标
				var newC = config.converterP2M(pixelCenter, mapConfig.scale);
				
				newcenterX = newC.Mx;
				newcenterY = newC.My;
			}
			
			// 更新
			//CLDCore.updateMapHandler(new CLDPoint(newcenterX, newcenterY),offSetX,offSetY,lastStep);
			
			
		
		}
		public static function getOffsetMapXY(offSetX, offSetY,mapConfig:MapConfig,mapW:Number,mapH:Number,center:Point){
			var tilemapindex=mapConfig.tilemapindex;
			if(tilemapindex <= 1 || tilemapindex == 3 || tilemapindex == 4){
				var cPoint = new CLDPoint(
					(center.x)-offSetX*mapConfig.wscale,
					(center.y)+offSetY*mapConfig.hscale
				);
				var aPoint = new CLDPoint(
					mapConfig.x+mapW/2*mapConfig.wscale,
					mapConfig.y-mapH/2*mapConfig.hscale
				);
				var bPoint = new CLDPoint(
					mapConfig.x+mapConfig.width-mapW/2*mapConfig.wscale,
					mapConfig.y-mapConfig.height+mapH/2*mapConfig.hscale
				);
				
				if(cPoint.x<aPoint.x){
					if(offSetX>0){
						offSetX = 0;
					}
				}
				if(cPoint.x>bPoint.x){
					if(offSetX<0){
						offSetX = 0;
					}
				}
				
				if(cPoint.y>aPoint.y){
					if(offSetY>0){
						offSetY = 0;
					}
				}
				if(cPoint.y<bPoint.y){
					if(offSetY<0){
						offSetY = 0;
					}
				}
			}
			else if(tilemapindex == 2 ||tilemapindex == 8){
				var pixC = config.pointToPixel_3D_1(center.x, center.y, mapConfig.scale);
				var cPoint = {x: (pixC.x-offSetX), y: (pixC.y-offSetY)};
				var aPoint = {x: (mapW/2), y: (mapH/2)};
				var bPoint = {x: (mapConfig.pixelwidth-mapW/2), y: (mapConfig.pixelheight-mapH/2)};
				
				if(cPoint.x<aPoint.x){
					if(offSetX>0){
						offSetX = 0;
					}
				}
				if(cPoint.x>bPoint.x){
					if(offSetX<0){
						offSetX = 0;
					}
				}
				
				if(cPoint.y<aPoint.y){
					if(offSetY>0){
						offSetY = 0;
					}
				}
				if(cPoint.y>bPoint.y){
					if(offSetY<0){
						offSetY = 0;
					}
				}
			}
			else if(tilemapindex == 5 ||tilemapindex == 6){
				var pixC = config.pointToPixel_3D_2(center.x, center.y, mapConfig.scale);
				var cPoint = {x: (pixC.x-offSetX), y: (pixC.y-offSetY)};
				var aPoint = {x: (mapW/2), y: (mapH/2)};
				var bPoint = {x: (mapConfig.pixelwidth-mapW/2), y: (mapConfig.pixelheight-mapH/2)};
				
				if(cPoint.x<aPoint.x){
					if(offSetX>0){
						offSetX = 0;
					}
				}
				if(cPoint.x>bPoint.x){
					if(offSetX<0){
						offSetX = 0;
					}
				}
				
				if(cPoint.y<aPoint.y){
					if(offSetY>0){
						offSetY = 0;
					}
				}
				if(cPoint.y>bPoint.y){
					if(offSetY<0){
						offSetY = 0;
					}
				}
			}
			else if(tilemapindex == 7){
				var pixC = config.converterM2P({Mx:center.x, My:center.y}, mapConfig.scale);
				var cPoint = {x: (pixC.Px-offSetX), y: (pixC.Py-offSetY)};
				var aPoint = {x: (mapConfig.x+mapW/2), y: (mapConfig.y+mapH/2)};
				var bPoint = {x: (mapConfig.pixelwidth-mapW/2), y: (mapConfig.pixelheight-mapH/2)};
				
				if(cPoint.x<aPoint.x){
					if(offSetX>0){
						offSetX = 0;
					}
				}
				if(cPoint.x>bPoint.x){
					if(offSetX<0){
						offSetX = 0;
					}
				}
				
				if(cPoint.y<aPoint.y){
					if(offSetY>0){
						offSetY = 0;
					}
				}
				if(cPoint.y>bPoint.y){
					if(offSetY<0){
						offSetY = 0;
					}
				}
			}
			
			return [offSetX,offSetY];
		};
		
		
	}
}