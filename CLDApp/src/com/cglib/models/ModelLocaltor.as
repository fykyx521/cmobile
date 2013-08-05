package com.cglib.models
{
	public class ModelLocaltor
	{
		protected static var _instance:ModelLocaltor;
		public function ModelLocaltor(force:singletonForce)
		{
		}
		public static function getInstance():ModelLocaltor{
			if(_instance==null){
				_instance=new ModelLocaltor(new singletonForce());
			}
			return _instance;		
		}
	}
}
class singletonForce{ 
	public function singletonForce(){}
}