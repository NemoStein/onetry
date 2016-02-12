package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	import sourbit.games.onetry.player.Player;
	import sourbit.games.onetry.scenes.LevelComplete;
	import sourbit.games.onetry.scenes.Pause;
	import sourbit.games.onetry.sonds.SoundSequencePlayer;
	import sourbit.games.onetry.states.LevelFailed;
	import sourbit.games.onetry.ui.ingame.HUD;
	
	public class Global
	{
		static public const VERSION:String = String(new Assets.VERSION());
		
		public static const GRAVITY:int = 900;
		public static const TILE_SIDE:int = 16;
		
		public static var assetsHolder:Object = [];
		
		public static var god:Boolean;
		public static var complete:Boolean;
		static public var completeCheated:Boolean;
		public static var lost:Boolean;
		
		public static var failedType:String;
		public static var texts:Object;
		
		public static var levelComplete:LevelComplete;
		public static var levelFailed:LevelFailed;
		public static var pause:Pause;
		
		public static var player:Player;
		
		public static var hooks:int;
		
		public static var currentLevel:int;
		public static var levelsIDs:Array;
		public static var levelsReferences:Vector.<*>;
		public static var levels:Vector.<Class>;
		public static var levelsCompleted:Vector.<int>;
		public static var times:Vector.<int>;
		
		public static var hud:HUD;
		public static var effectsCamera:FlxCamera;
		
		public static var currentTime:Number;
		public static var bestTimes:Vector.<Number>;
		
		public static var backGroundMap:FlxTilemap;
		public static var groundMap:FlxTilemap;
		
		public static var decalsMap1:FlxTilemap;
		public static var decalsMap2:FlxTilemap;
		public static var decalsMap3:FlxTilemap;
		
		public static var hasKey:Boolean;
		
		public static var layer1:FlxGroup;
		public static var layer2:FlxGroup;
		public static var layer3:FlxGroup;
		public static var layer4:FlxGroup;
		public static var layer5:FlxGroup;
		public static var layer6:FlxGroup;
		
		public static var TO_ALPHA:uint = 0xffC800C8;
		public static var NEW_ALPHA:uint = 0x30000000;
		
		public static var report:ReportProxy;
		
		public static var musicSequence:SoundSequencePlayer;
		
		
		static public function menuMoveUp():Boolean
		{
			return (FlxG.keys.justPressed("UP"))
		}
		
		static public function menuMoveDown():Boolean
		{
			return (FlxG.keys.justPressed("DOWN"))
		}
		
		static public function menuAccept():Boolean
		{
			return (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C"))
		}
		
		static public function menuRestart():Boolean
		{
			return (FlxG.keys.justPressed("R"));
		}
		
		static public function menuPause():Boolean
		{
			return (FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P"));
		}
		
		static public function menuMute():Boolean
		{
			return (FlxG.keys.justPressed("M"));
		}
		
		static public function menuDebugGodMode():Boolean
		{
			return (FlxG.keys.justPressed("G"));
		}
		
		static public function menuDebugBeatLevel():Boolean
		{
			return (FlxG.keys.justPressed("K"));
		}
		
		static public function menuDebugShowCollision():Boolean
		{
			return (FlxG.keys.justPressed("B"));
		}
	}
}