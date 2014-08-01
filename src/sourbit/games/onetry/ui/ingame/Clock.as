package sourbit.games.onetry.ui.ingame 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	public class Clock extends FlxGroup 
	{
		private var _bg:FlxSprite;
		private var _text:FlxBitmapFont;
		
		private var _time:Number;
		private var _couting:Boolean;
		
		public var x:int;
		public var y:int;
		
		public function Clock(x:int,y:int) 
		{
			super();
			
			this.x = x;
			this.y = y;
			
			_bg = new FlxSprite(x, y, Global.assetsHolder[Assets.HUD]);
			_bg.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_text = new FlxBitmapFont(Global.assetsHolder[Assets.TIMER_FONT_GREEN], 4, 9, "0123456789_:.", 13);
			
			_text.x = x + 5;
			_text.y = y + 13;
			
			_time = 0;
			
			add(_bg);
			add(_text);
			
			setAll("scrollFactor", new FlxPoint());
		}
		
		override public function update():void 
		{
			if (_couting)
			{
				_time += FlxG.elapsed;
			}
			
			_text.setText(FlxU.formatTime(_time, true, 3), false, 1, 0, FlxBitmapFont.ALIGN_CENTER, false);
			
			super.update();
		}
		
		public function start():void
		{
			_couting = true;
		}
		
		public function pause():void
		{
			_couting = false;
		}
		
		public function setTime(value:Number):void
		{
			_time = value;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function get couting():Boolean 
		{
			return _couting;
		}
		
	}

}