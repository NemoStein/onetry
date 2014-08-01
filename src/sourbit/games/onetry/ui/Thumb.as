package sourbit.games.onetry.ui 
{
	import sourbit.games.onetry.states.Loader;
	import sourbit.games.onetry.states.Play;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class Thumb extends FlxButton 
	{
		public var animating:Boolean;
		
		private var _level:int;
		
		private var _unloked:Boolean;
		
		private var _levelText:FlxText;
		private var _timeText:FlxText;
		
		private var _stars:FlxSprite;
		
		private var _passive:int;
		private var _easy:int;
		private var _medium:int;
		private var _hard:int;
		private var _unfair:int;
		
		public function Thumb(x:int, y:int, level:int, unlocked:Boolean, beated:int=0)
		{
			_levelText = new FlxText(x + 6, y + 4, 16, "",true);
			_levelText.setFormat("Lead", 8, 0x2E2716, "left", 0x938876);
			
			_timeText = new FlxText(x + 6, y + 14, 60, "", true);
			_timeText.setFormat("Lead", 8, 0x2E2716, "left", 0x938876);
			
			_stars = new FlxSprite(x + 22, y + 8);
			_stars.loadGraphic(Global.assetsHolder[Assets.LEVEL_SELECT_SLOT_STARS], true, false, 39, 7);
			_stars.frame = beated-1;
			
			if (beated == 0)
			{
				_stars.visible = false;
			}
			
			var str:String = "";
			var helper:String = (level + 1).toString();
			
			_level = level;
			_unloked = unlocked;
			
			if (helper.length < 2)
			{
				str += "0";
			}
			
			str += helper;
			_levelText.text = str;
			
			if (_unloked)
			{
				_timeText.text = FlxU.formatTime( Global.bestTimes[_level], true, 3);
			}
			
			super(x, y, null, null);
			
			loadGraphic(Global.assetsHolder[Assets.LEVEL_SELECT_SLOT], true, false, 71, 35);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			if (!_unloked)
			{
				alpha = .5;
				_levelText.alpha = .5;
				_stars.alpha = 0;
			}
			
			onUp = callLevel;
			onOut = out;
			onOver = over;
			onDown = down;
		}
		
		public function refresh():void
		{
			_levelText.x = x + 6;
			_levelText.y = y + 4;
			
			_timeText.x = x + 6;
			_timeText.y = y + 14;
			
			_stars.x = x + 22;
			_stars.y = y + 8;
		}
		
		private function down():void 
		{
			if (animating || alpha == .5) return;
			
			_levelText.x = x + 7;
			_levelText.y = y + 5;
			
			_timeText.x = x + 7;
			_timeText.y = y + 15;
			
			_stars.x = x + 23;
			_stars.y = y + 9;
			
			_levelText.color = 0x2E2716;
			_levelText.shadow = 0x938876;
			
			_timeText.color = 0x2E2716;
			_timeText.shadow = 0x938876;
			
			FlxG.play(PressSFX);
		}
		
		private function out():void
		{
			if (animating || alpha == .5) return;
			
			_levelText.x = x + 6;
			_levelText.y = y + 4;
			
			_timeText.x = x + 6;
			_timeText.y = y + 14;
			
			_stars.x = x + 22;
			_stars.y = y + 8;
			
			_levelText.color = 0x2E2716;
			_levelText.shadow = 0x938876;
			
			_timeText.color = 0x2E2716;
			_timeText.shadow = 0x938876;
		}
		
		private function over():void
		{
			if (animating || alpha == .5) return;
			
			_levelText.x = x + 5;
			_levelText.y = y + 3;
			
			_timeText.x = x + 5;
			_timeText.y = y + 13;
			
			_stars.x = x + 21;
			_stars.y = y + 7;
			
			_levelText.color = 0x4B3A2A;
			_levelText.shadow = 0xAFA795;
			
			_timeText.color = 0x4B3A2A;
			_timeText.shadow = 0xAFA795;
			
			FlxG.play(overSFX);
		}
		
		public function timesList (passive:int, easy:int, medium:int, hard:int, unfair:int):void
		{
			_passive = passive;
			_easy = easy;
			_medium = medium;
			_hard = hard;
			_unfair = unfair;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (alpha == .5)
			{
				active = false;
				frame = 3;
			}
			else
			{
				if (animating)
				{
					frame = NORMAL;
					status = NORMAL;
				}
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			
			_levelText.draw();
			_timeText.draw();
			
			if (_stars.visible)
			{
				_stars.draw();
			}
		}
		
		public function callLevel():void
		{
			if (!_unloked) return;
			
			FlxG.switchState( new Loader( Loader.IN_GAME, Play, _level, true ));
		}
		
	}

}