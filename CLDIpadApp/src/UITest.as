package
{
	import com.careland.main.ui.item.CLDMenuItem;
	
	import flash.display.Sprite;
	
	public class UITest extends Sprite
	{
		public function UITest()
		{
			super();
			stage.align=flash.display.StageAlign.TOP_LEFT;
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			stage.quality=flash.display.StageQuality.HIGH;
			var menu:CLDMenuItem=new CLDMenuItem();
			this.addChild(menu);
			menu.data=<menu 菜单图片="assets/info.png" 点击菜单图片="assets/info.png"  ID="1187" 菜单名称="AIR菜单"></menu>;
			
		}
	}
}