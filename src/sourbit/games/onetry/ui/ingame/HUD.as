package sourbit.games.onetry.ui.ingame 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import sourbit.games.onetry.states.Play;
	
	public class HUD extends FlxGroup
	{
		private var _clock:Clock;
		
		private var _bgm:FlxButton;
		private var _sfx:FlxButton;
		
		private var _border:FlxSprite;
		
		public function HUD() 
		{
			super();
			
			_clock = new Clock(8, 0);
			
			_bgm = new FlxButton(360, 4, null, bgm);
			_sfx = new FlxButton(380, 4, null, sfx);
			
			_border = new FlxSprite(0, 0, Global.assetsHolder[Assets.BORDER]);
			
			_bgm.loadGraphic(Global.assetsHolder[Assets.BGM], true, false, 16, 16);
			_sfx.loadGraphic(Global.assetsHolder[Assets.SFX], true, false, 16, 16);
			
			_bgm.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			_sfx.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_bgm.on = true;
			_sfx.on = true;
			
			checkGraphics();
			
			if (FlxG.state is Play)
			{
				add(_clock);
			}
			
			_bgm.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_sfx.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			
			add(_bgm);
			add(_sfx);
			add(_border);
			
			setAll("scrollFactor", new FlxPoint());
		}
		
		override public function update():void 
		{
			_border.visible = Global.god;
			super.update();
		}
		
		private function checkGraphics():void
		{
			if (FlxG.mute)
			{
				_sfx.status = FlxButton.PRESSED;
				_sfx.frame = FlxButton.PRESSED;
			}
			else
			{
				_sfx.status = FlxButton.NORMAL;
				_sfx.frame = FlxButton.NORMAL;
			}
			if (Global.musicSequence)
			{
				if (!Global.musicSequence.active)
				{
					_bgm.status = FlxButton.PRESSED;
					_bgm.frame = FlxButton.PRESSED;
				}
				else
				{
					_bgm.status = FlxButton.NORMAL;
					_bgm.frame = FlxButton.NORMAL;
				}
			}
		}
		
		public function toggle():void 
		{
			toggleBGM();
			toggleSFX();
			
			checkGraphics();
		}
		
		private function bgm():void
		{
			var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
			if (mouse.x > _bgm.x && mouse.x < _bgm.x + _bgm.width && mouse.y > _bgm.y && mouse.y < _bgm.y + _bgm.height && FlxG.mouse.visible)
			{
				toggleBGM();
			}
		}
		
		private function sfx():void
		{
			var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
			if (mouse.x > _sfx.x && mouse.x < _sfx.x + _sfx.width && mouse.y > _sfx.y && mouse.y < _sfx.y + _sfx.height && FlxG.mouse.visible)
			{
				toggleSFX();
			}
		}
		
		private function toggleBGM():void
		{
			if (Global.musicSequence)
			{
				if (Global.musicSequence.active)
				{
					Global.musicSequence.pause();
				}
				else
				{
					Global.musicSequence.resume();
				}
			}
		}
		
		private function toggleSFX():void
		{
			FlxG.mute = !FlxG.mute;
		}
		
		public function hovering():Boolean
		{
			var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
			return mouse.x > _bgm.x && mouse.x < _sfx.x + _sfx.width && mouse.y > _bgm.y && mouse.y < _bgm.y + _bgm.height;
		}
		
		public function get clock():Clock 
		{
			return _clock;
		}
	}
}