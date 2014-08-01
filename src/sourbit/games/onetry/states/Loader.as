package sourbit.games.onetry.states
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import sourbit.library.tools.AssetLoader;
	
	public class Loader extends FlxState
	{
		public static const HOME:String = "home";
		public static const IN_GAME:String = "inGame";
		
		private var _type:String;
		private var _next:Class;
		private var _args:Array;
		
		public function Loader(type:String, nextState:Class, ...nextStateArgs:Array)
		{
			_type = type;
			
			_next = nextState;
			_args = nextStateArgs;
		}
		
		override public function create():void
		{
			if (_type == HOME)
			{
				AssetLoader.load
				(
					loadComplete,
					Assets.LOGO,
					Assets.NEW_GAME,
					Assets.CONTINUE,
					Assets.CLOUDS,
					Assets.PARALLAX1,
					Assets.PARALLAX2,
					Assets.PARALLAX3,
					Assets.PARALLAX4,
					Assets.TOWER,
					Assets.BUTTON_BLANK,
					Assets.BACK,
					Assets.LEVEL_SELECT_SLOT,
					Assets.LEVEL_SELECT_SLOT_STARS,
					Assets.LEVEL_SELECT_RIGHT_ARROW,
					Assets.LEVEL_SELECT_LEFT_ARROW,
					Assets.BGM,
					Assets.SFX,
					Assets.HUD,
					Assets.BORDER,
					Assets.TIMER_FONT_GREEN
				);
			}
			else
			{
				var current:int = _args[0];
				
				AssetLoader.load
				(
					loadComplete,
					Assets.TILESET,
					Assets.TILESET_BG,
					Assets.TILESET_DECALS,
					Assets.PLAYER,
					Assets.PLAYER_SPECIAL,
					Assets.TIMER_FONT_GREEN,
					Assets.TIMER_FONT_RED,
					Assets.BGM,
					Assets.SFX,
					Assets.HUD,
					Assets.COIL,
					Assets.DOOR,
					Assets.DROP_PLATFORM,
					Assets.KEY,
					Assets.LIFT_PLATFORM,
					Assets.MOVING_PLATFORM,
					Assets.TRAPDOOR,
					Assets.TREADMILL,
					Assets.TIMER,
					Assets.SWITCH,
					Assets.JELLY,
					Assets.SMOKE_PARTICLE,
					Assets.WALL_HOOK,
					Assets.TEXTS,
					Assets.TELEPORTAL,
					Assets.TELEPORTAL_EFFECT,
					Assets.RETRACTABLE_PLATFORM,
					Assets.BORDER
				);
			}
		}
		
		private function loadComplete(map:Object):void
		{
			for (var path:String in map)
			{
				Global.assetsHolder[path] = map[path];
			}
			
			if (_type == HOME)
			{
				FlxG.switchState(new _next());
			}
			else
			{
				var text:String = new (Global.assetsHolder[Assets.TEXTS])();
				Global.texts = JSON.parse(text);
				FlxG.switchState(new _next(_args));
			}
		}
	}

}