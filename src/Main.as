package
{
	import flash.display.BitmapData;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import sourbit.games.onetry.states.Initial;
	import sourbit.library.tools.AssetLoader;
	
	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(400, 240, Initial, 2, 60, 60, false);
			
			FlxG.volume = .2;
			
			SOURBIT::mute
			{
				FlxG.volume = 0;
			}
			
			forceDebugger = true;
			useSoundHotKeys = false;
			
			Global.report = new Report();
			
			//Global.report.record('test/01', 11, 12, 13, Report.FAIL_BY_FALL);
			//Global.report.record('test/01', 21, 22, 23, Report.SUCCESS);
			//
			//Global.report.save();
			
			AssetLoader.load(function(map:Object):void
			{
				FlxG.mouse.load(map[Assets.CURSOR]);
				replaceColor(FlxG.mouse.cursor.bitmapData, Global.TO_ALPHA, Global.NEW_ALPHA);
			}, Assets.CURSOR);
		}
		
		private function replaceColor(bitmapData:BitmapData, oldColor:uint, newColor:uint):void
		{
			var row:uint = 0;
			var column:uint;
			var rows:uint = bitmapData.height;
			var columns:uint = bitmapData.width;
			
			while (row < rows)
			{
				column = 0;
				while (column < columns)
				{
					if (bitmapData.getPixel32(column, row) == oldColor)
					{
						bitmapData.setPixel32(column, row, newColor);
					}
					
					++column;
				}
				
				row++;
			}
		}
	}
}