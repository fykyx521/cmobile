package JTWC
{
	public class WeatherConfig
	{
		//获取天气
		public static var getWeatherUrl:String="http://10.245.101.68/dyhnew/DataServer/AjaxForInterface.aspx?Name=Comm&SpName=P_GetWeather&paramsString=";
		//台风路径
		public static var getWeatherTF:String="http://10.245.101.68/dyhnew/DataServer/AjaxForInterface.aspx?Name=Comm&SpName=P_GetTyphoonRoute";
		//预警
		public static var getWeatherYJ:String="http://10.245.101.68/dyhnew/DataServer/AjaxForInterface.aspx?Name=Comm&SpName=P_%E8%8E%B7%E5%8F%96%E6%B0%94%E8%B1%A1%E9%A2%84%E8%AD%A6";
		
		public static var getWeatherList:String="http://10.245.101.68/dyhNew/DataServer/AjaxPreview.aspx?id=2689";
		
		public static function GetWeatherImage(n:String):String
		{
			var imgName:String="Yahoo_Weather_011.png";
			switch(n)
			{
				case "晴"://晴
				{
					imgName="Yahoo_Weather_021.png";
					break;
				}
				case "多云"://多云
				{
					imgName="Yahoo_Weather_002.png";
					break;
				}
				case "阴"://阴
				{
					imgName="Yahoo_Weather_026.png";
					break;
				}
				case "阵雨"://阵雨
				{
					imgName="Yahoo_Weather_015.png";
					break;
				}
				case "雷阵雨"://雷阵雨
				{
					imgName="Yahoo_Weather_022.png";
					break;
				}
				case "雷阵雨伴有冰雹"://雷阵雨伴有冰雹
				{
					imgName="Yahoo_Weather_004.png";
					break;
				}
				case "雨夹雪"://雨夹雪
				{
					imgName="Yahoo_Weather_018.png";
					break;
				}
				case "小雨"://小雨
				{
					imgName="Yahoo_Weather_017.png";
					break;
				}
				case "中雨"://中雨
				{
					imgName="Yahoo_Weather_017.png";
					break;
				}
				case "大雨"://大雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "暴雨"://暴雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "大暴雪"://大暴雪
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "特大暴雨"://特大暴雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "阵雪"://阵雪
				{
					imgName="Yahoo_Weather_020.png";
					break;
				}
				case "小雪"://小雪
				{
					imgName="Yahoo_Weather_020.png";
					break;
				}
				case "中雪"://中雪
				{
					imgName="Yahoo_Weather_020.png";
					break;
				}
				case "大雪"://大雪
				{
					imgName="Yahoo_Weather_019.png";
					break;
				}
				case "暴雪"://暴雪
				{
					imgName="Yahoo_Weather_019.png";
					break;
				}
				case "雾"://雾
				{
					imgName="Yahoo_Weather_008.png";
					break;
				}
				case "冻雨"://冻雨
				{
					imgName="Yahoo_Weather_004.png";
					break;
				}
				case "沙尘暴"://沙尘暴
				{
					imgName="Yahoo_Weather_006.png";
					break;
				}
				case "小雨-中雨"://小雨-中雨
				{
					imgName="Yahoo_Weather_017.png";
					break;
				}
				case "中雨-大雨"://中雨-大雨
				{
					imgName="Yahoo_Weather_017.png";
					break;
				}
				case "大雨-暴雨"://大雨-暴雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "暴雨-大暴雨"://暴雨-大暴雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "大暴雨-特大暴雨"://大暴雨-特大暴雨
				{
					imgName="Yahoo_Weather_014.png";
					break;
				}
				case "小雪-中雪"://小雪-中雪
				{
					imgName="Yahoo_Weather_020.png";
					break;
				}
				case "中雪-大雪"://中雪-大雪
				{
					imgName="Yahoo_Weather_020.png";
					break;
				}
				case "大雪-暴雪"://大雪-暴雪
				{
					imgName="Yahoo_Weather_019.png";
					break;
				}
				case "浮尘"://浮尘
				{
					imgName="Yahoo_Weather_025.png";
					break;
				}
				case "扬沙"://扬沙
				{
					imgName="Yahoo_Weather_025.png";
					break;
				}
				case "强沙尘暴"://强沙尘暴
				{
					imgName="Yahoo_Weather_005.png";
					break;
				}
			}
			return imgName;
		}
	}
	
}