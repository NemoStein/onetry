package sourbit.games.onetry.props 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.system.FlxTile;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.player.behaviors.custom.Grabbed;
	import sourbit.games.onetry.player.Player;
	import sourbit.games.onetry.props.switches.Wired;
	
	public class DropPlatform extends Entity
	{
		protected static const DROPED:int = 0;
		protected static const LIFTED:int = 1;
		
		private var _state:int;
		
		public var hitted:Boolean;
		
		private var _timer:Number = 0;
		private var _delay:Number = .35;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		public function DropPlatform(id:int, x:int,y:int)
		{
			super(id, x, y);
		}
		
		override protected function initialize():void 
		{
			_state = LIFTED;
			
			super.initialize();
			
			immovable = true;
			allowCollisions = UP;
		}
		
		override public function update():void 
		{
			if (hitted)
			{
				_timer += FlxG.elapsed;
				
				if (_timer >= _delay)
				{
					drop();
				}
			}
			
			super.update();
		}
		
		private function drop():void
		{
			play("drop");
			
			solid = false;
			
			_state = DROPED;
			
			FlxG.play(DropPlatformSFX);
		}
		
		private function lift():void
		{
			active = true;
			solid = true;
			
			_state = LIFTED;
			
			play("lift");
			
			FlxG.play(DropPlatformSFX);
		}
		
		override protected function checkGraphic():void 
		{
			loadGraphic(Global.assetsHolder[Assets.DROP_PLATFORM], true, false, 20, 13);
			
			width =  16;
			height = 13;
			
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
		}
		
		override protected function checkAnimation():void 
		{
			addAnimationCallback(finish);
			addAnimation("drop", [0, 1, 2, 3, 4], 24, false);
			addAnimation("lift", [4, 3, 2, 1, 0], 24, false);
		}
		
		private function finish(name:String, frame:uint, index:uint):void
		{
			if (name == "drop" && index == 4)
			{
				active = false;
			}
		}
	}
}