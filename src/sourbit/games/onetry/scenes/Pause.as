package sourbit.games.onetry.scenes
{
	import org.flixel.FlxCamera;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.props.teleportal.Teleportal;
	import sourbit.games.onetry.states.Home;
	import sourbit.games.onetry.states.LevelSelect;
	import sourbit.games.onetry.states.Loader;
	import sourbit.games.onetry.states.Play;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import sourbit.games.onetry.ui.BasicButton;
	
	public class Pause extends FlxGroup
	{
		private var _fade:FlxSprite;
		private var _title:FlxText;
		private var _resumeButton:BasicButton;
		private var _restartButton:BasicButton;
		private var _quitButton:BasicButton;
		
		private var _navigator:Array;
		private var _selected:int;
		
		public function Pause()
		{
			super();
			
			FlxG.mouse.show();
			
			_fade = new FlxSprite();
			_fade.makeGraphic(FlxG.width, FlxG.height, 0x80000000);
			
			_title = new FlxText(FlxG.width / 2 - 200, 10, 400, "GAME PAUSED");
			_title.alignment = "center";
			_title.size = 24;
			
			_navigator = [];
			
			_resumeButton = new BasicButton(FlxG.width / 2 - 52 / 2, (FlxG.height / 2) - 29 , "resume", resume);
			_restartButton = new BasicButton(FlxG.width / 2 - 52 / 2, (FlxG.height / 2)  , "reset", restart);
			_quitButton = new BasicButton(FlxG.width / 2 - 52 / 2, (FlxG.height / 2) + 29,  "menu", quit);
			
			_navigator.push(_resumeButton);
			_navigator.push(_restartButton);
			_navigator.push(_quitButton);
			
			_resumeButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_restartButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_quitButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			
			_selected = 0;
			
			add(_fade);
			add(_title);
			add(_resumeButton);
			add(_restartButton);
			add(_quitButton);
			
			setAll("scrollFactor", new FlxPoint());
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
					_selected = _navigator.length-1;
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
				if(hovering(_navigator[i] as FlxButton))
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
		
		public function start():void
		{
			FlxG.mouse.show();
			exists = true;
		}
		
		public function resume():void
		{
			Teleportal.showCameras();
			
			FlxG.mouse.hide();
			FlxG.paused = false;
			exists = false;
		}
		
		public function restart():void
		{
			CONFIG::debug
			{
				LevelLoader.reloadCurrent();
			}
			
			Global.report.record("levelRestartByPause", Global.levelsIDs[Global.currentLevel]).save();
			
			resume();
			FlxG.switchState( new Loader(Loader.IN_GAME, Play, Global.currentLevel, true));
		}
		
		public function quit():void
		{
			resume();
			FlxG.switchState( new LevelSelect());
		}
		
	}

}