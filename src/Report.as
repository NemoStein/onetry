package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	
	public class Report
	{
		public static const RESTART_BY_R:String = "RestartByR";
		public static const RESTART_BY_MENU:String = "RestartByMenu";
		public static const FAIL_BY_FALL:String = "FailByFall";
		public static const FAIL_BY_TIME:String = "FailByTime";
		public static const FAIL_BY_CRUSH:String = "FailByCrush";
		public static const SUCCESS:String = "Success";
		
		private var _id:String;
		
		private var _request:URLRequest;
		private var _loader:URLLoader;
		private var _data:Array;
		private var _timer:Timer;
		private var _sending:Boolean;
		
		public function Report()
		{
			_id = (new Date()).valueOf() + '-' + String(Math.random()).substr(2, 8);
			
			_loader = new URLLoader();
			_request = new URLRequest("http://localhost:8080/api/onetry/reports/");
			_request.contentType = "application/json";
			_request.method = URLRequestMethod.POST;
			
			resetData();
			
			_loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
			
			_timer = new Timer(60000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
		}
		
		public function record(level:String, x:int, y:int, time:int, type:String):Report
		{
			_data.push({
				id: _id,
				level: level,
				x: x,
				y: y,
				time: time,
				type: type
			});
			
			return this;
		}
		
		public function save():void
		{
			if (_data.length > 0 && !_sending)
			{
				_sending = true;
				_request.data = JSON.stringify(_data);
				
				trace(_request.data);
				
				_loader.load(_request);
			}
		}
		
		private function onTimerTimer(event:TimerEvent):void 
		{
			save();
		}
		
		private function onLoaderIoError(event:IOErrorEvent):void
		{
			_sending = false;
			
			trace("Couldn't save the Report");
			trace(event.text);
		}
		
		private function onLoaderComplete(event:Event):void
		{
			_sending = false;
			
			resetData();
		}
		
		private function resetData():void
		{
			_data = [];
		}
		
		private function trim(value:String):String
		{
			var result:String;
			
			if (value != null)
			{
				result = String(value).replace(/^\s*(.*?)\s*$/g, "$1");
			}
			else
			{
				result = "";
			}
			
			return result;
		}
	}
}