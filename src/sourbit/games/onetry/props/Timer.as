package sourbit.games.onetry.props
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.props.switches.Wired;
	import sourbit.library.tools.Delay;
	
	public class Timer extends Entity implements Wired
	{
		public static const ONCE:String = "once";
		public static const LOOP:String = "loop";
		public static const RESET:String = "reset";
		
		private var _type:String;
		
		public var wired:Vector.<Wired>;
		private var _ids:Array;
		
		private var _fontGreen:FlxBitmapFont;
		private var _fontRed:FlxBitmapFont;
		
		private var _current:Number;
		private var _total:Number;
		
		private var _loopDelay:Delay;
		private var _endDelay:Delay;
		private var _resetDelay:Delay;
		
		private var _working:Boolean;
		private var _inverse:Boolean;
		private var _over:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		private var _displayTime:String;
		private var _oldDisplayTime:String;
		
		private var _flickerDelay:Delay;
		private var _showUnderscore:Boolean;
		
		public function Timer(id:int, x:int, y:int, time:Number, wiredTo:String, type:String, initial:Number)
		{
			_current = _total = time;
			if (initial > 0)
			{
				_current = initial;
			}
			
			_totalConnections = 0;
			_currentConnected = 0;
			
			_over = false;
			_showUnderscore = false;
			_working = true;
			
			_type = type;
			
			_endDelay = new Delay(1, false, function():void { _showUnderscore = true } );
			_loopDelay = new Delay(0.1, false, function():void { _current = _total } );
			_resetDelay = new Delay(1, false, function():void
			{
				_current = _total;
				_working = false;
			} );
			
			_flickerDelay = new Delay(.5, true, function():void { _showUnderscore = !_showUnderscore } );
			
			super(id, x, y);
			
			_ids = wiredTo.split(",");
			wired = new Vector.<Wired>();
		}
		
		public function setUpIds():void
		{
			var i:int = -1;
			while (++i < _ids.length)
			{
				wired.push(LevelLoader.getByID(_ids[i]) as Wired);
				
				if (wired[wired.length-1] is Timer)
				{
					var timer:Timer = wired[wired.length - 1];
					timer._working = false;
				}
			}
		}
		
		override protected function initialize():void
		{
			_fontGreen = new FlxBitmapFont(Global.assetsHolder[Assets.TIMER_FONT_GREEN], 4, 9, "0123456789_:.", 13);
			_fontRed = new FlxBitmapFont(Global.assetsHolder[Assets.TIMER_FONT_RED], 4, 9, "0123456789_:.", 13);
			
			_fontGreen.setText("00", false, 1, 0, FlxBitmapFont.ALIGN_CENTER);
			_fontRed.setText("00", false, 1, 0, FlxBitmapFont.ALIGN_CENTER);
			
			_fontGreen.x = _fontRed.x = x + 3;
			_fontGreen.y = _fontRed.y = y + 4;
			
			super.initialize();
		}
		
		override public function update():void
		{
			_oldDisplayTime = _displayTime;
			_displayTime = FlxU.formatTime(Math.ceil(_current)).slice(3, 5);
			
			if (!started)
			{
				updateDisplayFont(false);
				super.update();
				return;
			}
			
			if (_working)
			{
				if (_flickerDelay.active)
				{
					_flickerDelay.pause();
					_showUnderscore = false;
					
					updateDisplayFont(true);
				}
				
				_current -= FlxG.elapsed;
				if (_current <= 0)
				{
					_current = 0;
					updateDisplayFont(false);
					
					if (_type == ONCE)
					{
						_working = false;
						_over = true;
						
						wired.forEach( doToggle );
					}
					else if(_type == LOOP)
					{
						if (!_loopDelay.active)
						{
							wired.forEach( doToggle );
							_loopDelay.start();
						}
					}
					else if (_type == RESET)
					{
						_over = true;
						if (!_resetDelay.active)
						{
							wired.forEach( doToggle );
							_resetDelay.start();
						}
					}
				}
				else
				{
					updateDisplayFont(false);
				}
			}
			else
			{
				if (_type == LOOP || _type == RESET || (_type == ONCE  && !_over))
				{
					if (!_flickerDelay.active)
					{
						_flickerDelay.start();
					}
					
					_flickerDelay.update();
					updateDisplayFont(true, _showUnderscore);
				}
				else if (_type == ONCE)
				{
					if (!_endDelay.active && _over)
					{
						_endDelay.start();
					}
					
					if (_over)
					{
						updateDisplayFont(true, _showUnderscore);
					}
					else
					{
						updateDisplayFont(false);
					}
				}
			}
			
			_endDelay.update();
			_loopDelay.update();
			_resetDelay.update();
			super.update();
		}
		
		private function updateDisplayFont(force:Boolean, showUnderscore:Boolean=false):void
		{
			var text:String = showUnderscore ? "__" : _displayTime;
			
			if (_displayTime != _oldDisplayTime || force)
			{
				if (_current > 3)
				{
					_fontGreen.setText(text, false, 1, 0, FlxBitmapFont.ALIGN_CENTER);
				}
				else
				{
					_fontRed.setText(text, false, 1, 0, FlxBitmapFont.ALIGN_CENTER);
				}
			}
		}
		
		private function doToggle(item:Wired, index:int, vector:Vector.<Wired> ):void
		{
			if (item != null)
			{
				item.toggle();
			}
		}
		
		override protected function checkGraphic():void
		{
			makeGraphic(16, 16, 0x00000000, true);
		}
		
		override public function draw():void
		{
			super.draw();
			
			if (_current > 3)
			{
				_fontGreen.scrollFactor = scrollFactor;
				_fontGreen.cameras = cameras;
				_fontGreen.draw();
			}
			else
			{
				_fontRed.scrollFactor = scrollFactor;
				_fontRed.cameras = cameras;
				_fontRed.draw();
			}
		}
		
		/* INTERFACE game.props.switches.Wired */
		public function makeConnection(on:Boolean):void
		{
			++totalConnections;
			
			_working = on;
		}
		
		public function get totalConnections():int
		{
			return _totalConnections;
		}
		
		public function getEntity():Entity
		{
			return this as Entity;
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
			if (_type == ONCE && _over) return;
			
			++_currentConnected;
			if (_currentConnected == _totalConnections)
			{
				updateDisplayFont(true);
				_working = !_inverse;
			}
		}
		
		public function deactivate():void
		{
			if (_type == ONCE && _over) return;
			
			--_currentConnected;
			_working = _inverse;
		}
		
		public function toggle():void
		{
			_working = !_working;
		}
		
	}

}