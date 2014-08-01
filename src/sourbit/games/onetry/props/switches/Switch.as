package sourbit.games.onetry.props.switches
{
	import org.flixel.FlxG;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.player.Player;
	import sourbit.library.tools.Delay;
	
	public class Switch extends Entity
	{
		protected static const OFF:int = 0;
		protected static const ON:int = 1;
		
		private var _initial:int;
		private var _reset:Number;
		
		private var _resetDelay:Delay;
		
		public var wired:Vector.<Wired>;
		public var user:Player;
		
		protected var _state:int;
		protected var _type:String;
		
		private var _toggledThisFrame:Boolean;
		
		public function Switch(id:int, x:int, y:int,wiredToID:String, on:Boolean, reset:Number)
		{
			var ids:Array = wiredToID.split(",");
			wired = new Vector.<Wired>();
			
			var i:int = -1;
			while (++i < ids.length)
			{
				wired.push(LevelLoader.getByID(ids[i]) as Wired);
				wired[i].makeConnection(on);
			}
			
			_state = _initial = on ? ON : OFF;
			_reset = reset;
			
			if (_reset >= 0)
			{
				_resetDelay = new Delay(_reset, false,  toggle);
			}
			
			super(id, x, y);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if (_state == OFF)
			{
				frame = 9;
			}
			
			finished = true;
		}
		
		override protected function checkGraphic():void
		{
			loadGraphic(Global.assetsHolder[Assets.SWITCH], true, false, 10, 17);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			x += 4;
		}
		
		override protected function checkAnimation():void
		{
			addAnimation("deactivate", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 24, false);
			addAnimation("activate", [9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 24, false);
		}
		
		override public function update():void
		{
			_toggledThisFrame = false;
			
			if (_resetDelay)
			{
				_resetDelay.update();
			}
			
			super.update();
		}
		
		public function onOverlap():void
		{
			if (Global.player.key("justPressed", Global.player.keyMap.action) && !_toggledThisFrame && finished)
			{
				_toggledThisFrame = true;
				toggle();
			}
		}
		
		public function toggle():void
		{
			if (_state == ON)
			{
				_state = OFF;
				
				wired.forEach( deactivate );
				
				play("deactivate");
				
				FlxG.play(SwitchSFX);
			}
			else
			{
				_state = ON;
				
				wired.forEach( activate );
				
				play("activate");
				
				FlxG.play(SwitchSFX);
			}
			
			if (_reset >= 0)
			{
				if (_state != _initial)
				{
					_resetDelay.start();
				}
				else
				{
					_resetDelay.pause();
				}
			}
		}
		
		private function activate(item:Wired, index:int, vector:Vector.<Wired>):void
		{
			item.activate();
		}
		
		private function deactivate(item:Wired, index:int, vector:Vector.<Wired>):void
		{
			item.deactivate();
		}
		
		public function get state():int
		{
			return _state;
		}
	}
}