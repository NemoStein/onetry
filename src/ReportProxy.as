package
{
	import sourbit.library.tools.Report;
	
	public class ReportProxy
	{
		private var report:Report;
		
		public function ReportProxy(serviceURL:String)
		{
			report = new Report(serviceURL);
		}
		
		private function willRecordData():Boolean
		{
			CONFIG::debug
			{
				return false;
			}
			
			return true;
		}
		
		public function record(name:*, ... data:Array):ReportProxy
		{
			if (willRecordData())
			{
				report.record.apply(report, [].concat(name, data));
			}
			
			return this;
		}
		
		public function recordGrouped(group:*, name:*, ... data:Array):ReportProxy
		{
			if (willRecordData())
			{
				report.recordGrouped.apply(report, [].concat(group, name, data));
			}
			
			return this;
		}
		
		public function save(onResultCallback:Function = null):ReportProxy
		{
			if (willRecordData())
			{
				report.save(onResultCallback);
			}
			
			return this;
		}
		
		public function get serviceURL():String
		{
			return report.serviceURL;
		}
		
		public function set serviceURL(value:String):void
		{
			report.serviceURL = value;
		}
	}
}