﻿///////////////////////////////////////////////////////////
//  YiDongEventDispatcher.as
//  Macromedia ActionScript Implementation of the Class YiDongEventDispatcher
//  Generated by Enterprise Architect
//  Created on:      12-����-2008 11:07:25
//  Original author: cg
///////////////////////////////////////////////////////////



package com.cglib.Events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * @author cg
	 * @version 1.0
	 * @created 12-����-2008 11:07:25
	 */
	
	public class myEventDispatcher extends EventDispatcher
	{
		private static var _instance:myEventDispatcher;
		public function myEventDispatcher(force:singletonForce,target:IEventDispatcher=null):void{
			super(target);
		}
		public static function getInstance():myEventDispatcher{
			if(_instance==null){
				_instance=new myEventDispatcher(new singletonForce(),null);
			}
			return _instance;		
		}
	}//end YiDongEventDispatcher	
}
class singletonForce{ 
	public function singletonForce(){}
}