package sourbit.games.onetry.props 
{
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.props.switches.Wired;
	import org.flixel.FlxG;
	import sourbit.games.onetry.states.LevelFailed;
	import sourbit.games.onetry.states.Play;
	
	public class Trapdoor extends Entity implements Wired
	{
		public static const OPEN:String = "open";
		public static const CLOSED:String = "closed";
		
		private var _state:String;
		
		private var _working:Boolean;
		private var _inverse:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		private var _once:Boolean;
		
		public function Trapdoor(id:int, x:int, y:int, opened:Boolean)
		{
			_state = opened ? OPEN : CLOSED;
			
			_totalConnections = 0;
			_currentConnected = 0;
			
			super(id, x, y);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			if (_state == OPEN)
			{
				solid = false
				frame = 10;
			}
			else
			{
				solid = true;
				play("idle");
				
				Global.groundMap.setTile( x/Global.TILE_SIDE, y/Global.TILE_SIDE, 1, false);
				Global.groundMap.setTile( x/Global.TILE_SIDE, (y/Global.TILE_SIDE) + 1, 1, false);
			}
			
			immovable = true;
		}
		
		override protected function checkGraphic():void 
		{
			loadGraphic(Global.assetsHolder[Assets.TRAPDOOR], true, false, 18, Global.TILE_SIDE * 2);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			width = 16;
		}		
		
		override protected function checkAnimation():void 
		{
			addAnimation("idle", [0, 1, 2, 3], 10);
			addAnimation("open", [4, 5, 6, 7, 8, 9, 10], 20, false);
			addAnimation("close", [11, 12, 13, 14, 15, 16], 20, false);
			
			addAnimationCallback(animationCallback);
		}
		
		private function animationCallback(name:String, frame:uint, index:uint):void 
		{
			if (name == "close" && index == 16)
			{
				play("idle");
			}
			
			if (name == "open" && finished)
			{
				solid = false;
			}
		}
		
		override public function update():void 
		{
			if (_state == CLOSED && Global.player != null)
			{
				var correctionOffset:int = 3;
				if (Global.player.x < x + width - correctionOffset && Global.player.x + Global.player.width > x + correctionOffset && Global.player.y + Global.player.height > y && Global.player.y < y + height)
				{
					frame = 0;
					(FlxG.state as Play).endByDeath(LevelFailed.FAILED_BY_CRUSH);
				}
			}
			
			super.update();
		}
		
		/* INTERFACE game.props.switches.Wired */
		public function makeConnection(on:Boolean):void
		{
			++totalConnections;
		}
		
		public function getEntity():Entity
		{
			return this as Entity;
		}
		
		public function get totalConnections():int 
		{
			return _totalConnections;
		}
		
		public function set totalConnections(value:int):void 
		{
			_totalConnections = value;
		}
		
		public function get currentConnected():int 
		{
			return _currentConnected;
		}
		
		public function set currentConnected(value:int):void 
		{
			_currentConnected = value;
		}
		
		public function activate():void 
		{
			++currentConnected;
			if (currentConnected == totalConnections)
			{
				_inverse ? close() : open();
			}
		}
		
		public function deactivate():void 
		{
			--currentConnected;
			_inverse ? open() : close();
		}
		
		public function toggle():void
		{
			changeState();
		}
		
		private function open():void
		{
			if (_state == OPEN) return;
			
			_state = OPEN;
			
			Global.groundMap.setTile( x / Global.TILE_SIDE, y / Global.TILE_SIDE, 0, false);
			Global.groundMap.setTile( x / Global.TILE_SIDE, (y / Global.TILE_SIDE) + 1, 0, false);
			
			play("open");
			
			FlxG.play(TrapdoorOpenSFX);
		}
		
		private function close():void
		{
			if (_state == CLOSED) return;
			
			_state = CLOSED;
			solid = true;
			
			play("close");
			
			Global.groundMap.setTile( x/Global.TILE_SIDE, y/Global.TILE_SIDE, 1, false);
			Global.groundMap.setTile( x / Global.TILE_SIDE, (y / Global.TILE_SIDE) + 1, 1, false);
			
			FlxG.play(TrapdoorCloseSFX);
		}
		
		private function changeState():void
		{
			if (_state == OPEN)
			{
				close();
			}
			else
			{
				open();
			}
		}
		
		public function get state():String 
		{
			return _state;
		}
	}

}