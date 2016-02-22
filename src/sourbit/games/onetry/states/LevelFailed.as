package sourbit.games.onetry.states
{
	import com.greensock.TweenLite;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import sourbit.games.onetry.props.teleportal.Teleportal;
	import sourbit.games.onetry.ui.BasicButton;
	
	public class LevelFailed extends FlxGroup
	{
		public static const FAILED_BY_TIME:String = "time";
		public static const FAILED_BY_FALL:String = "fall";
		public static const FAILED_BY_CRUSH:String = "crush";
		
		private var _fade:FlxSprite;
		
		private var _title:FlxText;
		private var _subtitle:FlxText;
		
		private var _restartButton:BasicButton;
		private var _quitButton:BasicButton;
		
		private var _navigator:Array;
		private var _selected:int;
		
		public function LevelFailed(type:String)
		{
			super();
			
			FlxG.mouse.show();
			
			//Global.report.record("levelFailedBy" + type.charAt(0).toUpperCase() + type.substring(1), Global.levelsIDs[Global.currentLevel]).save();
			
			_navigator = [];
			_selected = 0;
			
			_fade = new FlxSprite();
			_fade.makeGraphic(FlxG.width, FlxG.height, 0x80000000);
			
			_title = new FlxText(FlxG.width / 2 - 200, 10, 400, "LEVEL FAILED");
			_title.alignment = "center";
			_title.size = 24;
			
			_subtitle = new FlxText(FlxG.width / 2 - 300, _title.y + _title.height + 15, 600, getRandomText(type));
			_subtitle.alignment = "center";
			_subtitle.size = 8;
			
			_restartButton = new BasicButton(-52, (FlxG.height / 2) - 10, "reset", restart);
			_quitButton = new BasicButton(FlxG.width + 52, (FlxG.height / 2) + 19, "menu", quit);
			
			_restartButton.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			_quitButton.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			
			_restartButton.animating = true;
			_quitButton.animating = true;
			
			_navigator.push(_restartButton);
			_navigator.push(_quitButton);
			
			add(_fade);
			add(_title);
			add(_subtitle);
			add(_restartButton);
			add(_quitButton);
			
			setAll("scrollFactor", new FlxPoint());
			
			TweenLite.to(_restartButton, .6, {x: FlxG.width / 2 - 52 / 2});
			TweenLite.to(_quitButton, .6, {x: FlxG.width / 2 - 52 / 2, onComplete: animationEnd});
		}
		
		private function animationEnd():void
		{
			_restartButton.animating = false;
			_quitButton.animating = false;
		}
		
		private function getRandomText(type:String):String
		{
			var text:String = "Something went wrong!";
			
			if (type == FAILED_BY_TIME)
			{
				text = Global.texts.failing.timeout[int(Math.random() * Global.texts.failing.timeout.length)];
			}
			else if (type == FAILED_BY_FALL)
			{
				text = Global.texts.failing.fall[int(Math.random() * Global.texts.failing.fall.length)];
			}
			else if (type == FAILED_BY_CRUSH)
			{
				text = Global.texts.failing.crush[int(Math.random() * Global.texts.failing.crush.length)];
			}
			
			return text;
		}
		
		override public function update():void
		{
			Teleportal.hideCameras();
			
			super.update();
			
			var currentButton:FlxButton = _navigator[_selected] as FlxButton;
			
			if (!hovering(currentButton))
			{
				currentButton.status = FlxButton.HIGHLIGHT;
				currentButton.frame = FlxButton.HIGHLIGHT;
				currentButton.onOver();
			}
			
			if (Global.menuMoveUp())
			{
				currentButton.onOut();
				
				--_selected;
				if (_selected < 0)
				{
					_selected = _navigator.length - 1;
				}
				
				FlxG.play(overSFX);
			}
			else if (Global.menuMoveDown())
			{
				currentButton.onOut();
				
				++_selected;
				_selected %= _navigator.length;
				
				FlxG.play(overSFX);
			}
			
			if (Global.menuAccept())
			{
				currentButton.onUp();
				FlxG.play(PressSFX);
			}
			
			var i:int = -1;
			while (++i < _navigator.length)
			{
				if (hovering(_navigator[i] as FlxButton))
				{
					_selected = i;
				}
			}
		}
		
		private function hovering(button:FlxButton):Boolean
		{
			var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
			return mouse.x > button.x && mouse.x < button.x + button.width && mouse.y > button.y && mouse.y < button.y + button.height && FlxG.mouse.visible;
		}
		
		private function restart():void
		{
			Global.lost = false;
			
			FlxG.switchState(new Play([Global.currentLevel, true]));
		}
		
		private function quit():void
		{
			Global.lost = false;
			
			FlxG.switchState(new LevelSelect());
		}
	}
}