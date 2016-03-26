package sourbit.games.onetry.scenes
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import sourbit.games.onetry.props.teleportal.Teleportal;
	import sourbit.games.onetry.states.LevelSelect;
	import sourbit.games.onetry.states.Play;
	import sourbit.games.onetry.ui.BasicButton;
	
	public class LevelComplete extends FlxGroup
	{
		private var _fade:FlxSprite;
		
		private var _title:FlxText;
		private var _subtitle:FlxText;
		
		private var _currentTime:FlxText;
		private var _bestTime:FlxText;
		private var _new:Boolean;
		private var _newBestTime:FlxText;
		
		//effect
		private var _effectOn:Boolean;
		public var currentTimeNumber:Number;
		
		private var _nexLevelButton:BasicButton;
		private var _restartButton:BasicButton;
		private var _quitButton:BasicButton;
		
		private var _navigator:Array;
		private var _selected:int;
		
		public function LevelComplete()
		{
			super();
			
			FlxG.mouse.hide();
			
			_navigator = [];
			_selected = 0;
			
			_fade = new FlxSprite();
			_fade.makeGraphic(FlxG.width, FlxG.height, 0x80000000);
			
			_title = new FlxText(FlxG.width / 2 - 200, 10, 400, "LEVEL " + (Global.currentLevel+1) + " COMPLETE");
			_title.alignment = "center";
			_title.size = 24;
			
			_subtitle = new FlxText(FlxG.width / 2 - 300, _title.y + _title.height + 6, 600, "");
			_subtitle.alignment = "center";
			_subtitle.size = 8;
			
			_nexLevelButton = new BasicButton(-52, (FlxG.height / 2), "next", next);
			_restartButton = new BasicButton(FlxG.width+52, (FlxG.height / 2) + 29, "reset", restart);
			_quitButton = new BasicButton( -52, (FlxG.height / 2) + 58, "menu", quit);
			
			_nexLevelButton.animating = true;
			_restartButton.animating = true;
			_quitButton.animating = true;
			
			_navigator.push(_nexLevelButton);
			_navigator.push(_restartButton);
			_navigator.push(_quitButton);
			
			//times!
			Global.currentTime = Global.hud.clock.time;
			
			if (!Global.completeCheated)
			{
				//Global.report.recordGrouped("levelTime", Global.levelsIDs[Global.currentLevel], Global.currentTime.toFixed(3)).save();
			}
			
			//leveling up!
			var i:int = 0;
			while ( i < Global.times.length)
			{
				if (Global.currentTime > Global.times[i])
				{
					break;
				}
				
				++i;
			}
			
			if (Global.levelsCompleted[Global.currentLevel] == 0 || i > Global.levelsCompleted[Global.currentLevel])
			{
				Global.levelsCompleted[Global.currentLevel] = i;
			}
			
			if ( Global.currentTime < Global.bestTimes[ Global.currentLevel] || Global.bestTimes[ Global.currentLevel ] == 0)
			{
				Global.bestTimes [ Global.currentLevel ] = Global.currentTime;
				_new = true;
			}
			
			if (_new)
			{
				_subtitle.text = Global.texts.succeeding.faster[ int(Math.random() * Global.texts.succeeding.faster.length)];
			}
			else
			{
				_subtitle.text = Global.texts.succeeding.slower[ int(Math.random() * Global.texts.succeeding.slower.length)];
			}
			
			currentTimeNumber = 0;
			
			_currentTime = new FlxText(FlxG.width / 2 - 40, 75, 150, "time: " + FlxU.formatTime(0,true,3));
			_currentTime.alignment = "left";
			
			_bestTime = new FlxText(FlxG.width / 2 - 40, 75 + _currentTime.height + 5, 150, "best time: " + FlxU.formatTime( 0, true,3 ) );
			_bestTime.alignment = "left";
			
			_newBestTime = new FlxText(_bestTime.x - 25, 75 + _currentTime.height + 5, 25, "new");
			_newBestTime.color = 0xFFEEEE00;
			
			_nexLevelButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_restartButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_quitButton.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			
			add(_fade);
			add(_title);
			add(_subtitle);
			add(_nexLevelButton);
			add(_restartButton);
			add(_quitButton);
			
			add(_currentTime);
			add(_bestTime);
			
			setAll("scrollFactor", new FlxPoint());
			
			SaveGame.saveGame();
			
			startEffect();
		}
		
		public function startEffect():void
		{
			_effectOn = true;
			TweenMax.to(this, 1, { currentTimeNumber: Global.currentTime, onComplete: endEffect } );
			
			TweenLite.to( _nexLevelButton, .6, { x:FlxG.width / 2 - 52 / 2 } );
			TweenLite.to( _restartButton, .6, { x:FlxG.width / 2 - 52 / 2 } );
			TweenLite.to( _quitButton, .6, { x:FlxG.width / 2 - 52 / 2 } );
		}
		
		public function updateEffect():void
		{
			_currentTime.text = "time: " + FlxU.formatTime(currentTimeNumber, true, 3);
		}
		
		public function endEffect():void
		{
			FlxG.flash(0xFFFFFFFF, 0.4);
			
			_effectOn = false;
			
			_nexLevelButton.animating = false;
			_restartButton.animating = false;
			_quitButton.animating = false;
			
			if (_new)
			{
				add(_newBestTime);
				_newBestTime.scrollFactor = new FlxPoint();
			}
			
			_currentTime.text = "time: " + FlxU.formatTime(Global.currentTime, true, 3);
			_bestTime.text = "bestTime: " + FlxU.formatTime(Global.bestTimes[Global.currentLevel] , true, 3);
			
			FlxG.mouse.show();
		}
		
		override public function update():void
		{
			Teleportal.hideCameras();
			
			super.update();
			
			if (_effectOn)
			{
				updateEffect();
				
				if (Global.menuAccept())
				{
					TweenMax.killAll(true);
				}
				
				return;
			}
			
			var currentButton:FlxButton = _navigator[_selected] as FlxButton;
			
			if (!hovering(currentButton))
			{
				currentButton.status = FlxButton.HIGHLIGHT;
				currentButton.frame = FlxButton.HIGHLIGHT;
				currentButton.onOver();
			}
			
			if (Global.menuRestart())
			{
				restart();
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
		
		private function next():void
		{
			if ((Global.currentLevel + 1) < Global.levels.length)
			{
				FlxG.switchState( new Play([++Global.currentLevel, true]));
			}
			else
			{
				FlxG.switchState( new LevelSelect());
			}
		}
		
		private function restart():void
		{
			FlxG.switchState( new Play([Global.currentLevel, true]));
		}
		
		private function quit():void
		{
			FlxG.switchState( new LevelSelect());
		}
		
		
	}

}