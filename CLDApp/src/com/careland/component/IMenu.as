package com.careland.component
{
	import flash.geom.Point;
	
	public interface IMenu extends IDisponse
	{
		 function cloneImg():MenuBase;
		 function getTargetPoint():Point;
		 function getLevel():int;
	}
}