package JTWC.Services
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class WeatherServices
	{
		
		private var xmlService:HTTPService;
		private var method:Function;
		
		public function WeatherServices()
		{
			

		}
		
		public function getResultXml(xmlUrl:String, method:Function):void
		{
			this.method=method;
			xmlService=new HTTPService();
			xmlService.method="GET";
			xmlService.useProxy=false;
			xmlService.resultFormat=HTTPService.RESULT_FORMAT_XML;
			xmlService.addEventListener("result", httpResult);
			xmlService.url=xmlUrl;
			xmlService.send();
		} 
		
		private function httpResult(event:ResultEvent):void
		{
			resultXml(XML(event.result));
			
		}
		
		protected function resultXml(value:XML):void
		{
			method.call(null,value);
		}
	}
}