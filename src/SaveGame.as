package
{
	import org.flixel.FlxSave;
	import sourbit.games.onetry.map.LevelLoader;
	
	public class SaveGame
	{
		private static var _save:FlxSave;
		private static var _loaded:Boolean;
		
		public static function initialize():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("OneTry");
		}
		
		public static function checkSave():Boolean
		{
			return _save.data.validation;
		}
		
		public static function saveGame():void
		{
			_save.data.validation = true;
			_save.data.levelsComplete = Global.levelsCompleted;
			_save.data.bestTimes = Global.bestTimes;
		}
		
		public static function loadGame():void
		{
			var i:int = -1;
			var l:int = _save.data.levelsComplete.length;
			
			while (++i < l)
			{
				if (i <= Global.levelsCompleted.length)
				{
					Global.levelsCompleted[i] = _save.data.levelsComplete[i];
				}
				if (i <= Global.bestTimes.length)
				{
					Global.bestTimes[i] = _save.data.bestTimes[i];
				}
			}
		}
		
		public static function erase():void
		{
			_save.data.validation = false;
			
			LevelLoader.loadLevels();
			
			_save.data.levelsComplete = Global.levelComplete;
			_save.data.bestTimes = Global.bestTimes;
		}
	}

}