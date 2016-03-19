package
{
	
	public class LevelAction
	{
		private function testA(params:Array):void
		{
			trace("testA", params.length, params);
		}
		
		private function testB(params:Array):void
		{
			trace("testB", params.length, params);
		}
		
		private function testC(params:Array):void
		{
			trace("testC", params.length, params);
		}
		
		private function testD(params:Array):void
		{
			trace("testD", params.length, params);
		}
		
		private function testE(params:Array):void
		{
			trace("testE", params.length, params);
		}
		
		private function testF(params:Array):void
		{
			trace("testF", params.length, params);
		}
		
		/**
		 * Static API
		 */
		static private var instance:LevelAction;
		{
			instance = new LevelAction();
		}
		
		static public function execute(callString:String):Boolean
		{
			try
			{
				var callParts:Array = (/^\s*([a-zA-Z0-9_\$]+)\s*\(([^\)]+)*\)\s*$/).exec(callString) as Array;
				
				var method:String = callParts[1];
				var params:Array = [];
				
				if (callParts[2] !== undefined)
				{
					params = params.concat(callParts[2].split(/(?<!\\),/));
					
					for (var i:int = 0; i < params.length; ++i)
					{
						var string:String = params[i].replace("\\,", ",").replace(/^\s*(.*?)\s*$/, "$1");
						var number:Number = Number(string);
						
						if (!isNaN(number) && string != "")
						{
							params[i] = number;
						}
						else
						{
							params[i] = string;
						}
					}
				}
				
				try
				{
					instance[method](params);
					return true;
				}
				catch (error:ReferenceError)
				{
					trace("LevelAction \"" + method + "\" not found.");
					trace(error);
				}
				catch (error:Error)
				{
					trace("Failed to execute LevelAction \"" + method + "\".");
					trace(error);
				}
			}
			catch (error:Error)
			{
				trace("Failed to parse LevelAction call string \"" + callString + "\".");
				trace(error);
			}
			
			return false;
		}
	}
}