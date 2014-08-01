package sourbit.games.onetry.props.door 
{
	import org.flixel.FlxObject;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.player.behaviors.custom.PrepareToEnterDoor;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import sourbit.games.onetry.states.Play;
	
	public class Door extends FlxGroup 
	{
		private var _bg:FlxSprite;
		private var _door:DoorHit;
		private var _light:FlxSprite;
		private var _hero:FlxSprite;
		
		public var x:int;
		public var y:int;
		
		private var _timer:Number = 0;
		private var _delay:Number = 0;
		
		private var _anim:Boolean;
		
		private var _steps:Vector.<int>;
		private var _currentStep:int = -1;
		
		public function Door(id:int, x:int, y:int) 
		{
			super();
			
			this.x = x;
			this.y = y;
			
			initialize();
		}
		
		private function initialize():void 
		{
			_bg = new FlxSprite(x, y);
			_door = new DoorHit(x, y);
			_light = new FlxSprite(x, y);
			
			_bg.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27, 32);
			_door.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27,  32);
			_light.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27, 32);
			
			_bg.width = _door.width = _light.width = 26;
			
			_door.door = this;
			
			_hero = new FlxSprite(x, y + 8);
			_hero.loadGraphic(Global.assetsHolder[Assets.PLAYER_SPECIAL], true, true, 24, 24);
			_hero.addAnimation("getOut", [8, 9, 10, 11, 12, 13], 10, false);
			_hero.visible = false;
			
			_bg.frame = 6;
			_door.addAnimation("open", [0, 1, 2, 3, 4, 5], 24, false);
			_door.addAnimation("close", [5, 4, 3, 2, 1, 0], 10, false);
			
			_light.addAnimation("green", [6], 1, false);
			_light.addAnimation("red", [7], 1, false);
			_light.play("red");
			
			_bg.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			_door.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			_hero.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			add(_bg);
			add(_door);
			add(_hero);
			add(_light);
		}
		
		override public function update():void 
		{
			if (Global.player && !Global.player.exists && !_anim)
			{
				_hero.facing = Global.player.facing;
				
				if (_hero.facing == FlxObject.RIGHT)
				{
					_hero.x -= 1;
				}
				else
				{
					_hero.x += 5;
				}
				
				_anim = true;
			}
			
			if (_anim)
			{
				_timer += FlxG.elapsed;
				
				if (_timer >= _delay)
				{
					_timer = 0;
					_currentStep = _steps.pop();
				}
			}
			
			if (_currentStep == 0)
			{
				_currentStep = -1;
				
				_hero.visible = true;
				_door.play("close");
				_hero.play("getOut");
				
				_delay = ((1 / 10) * 6);
			}
			else if (_currentStep == 1)
			{
				_currentStep = -1;
				
				_delay = 1;
			}
			else if (_currentStep == 2)
			{
				_currentStep = -1;
				
				(FlxG.state as Play).endLevel(false);
			}
			
			super.update();
		}
		
		public function readyToEnter():void
		{
			_light.play("green");
			_door.play("open");
			
			FlxG.play(DoorSFX);
		}
		
		public function hit():void
		{
			if (!Global.hasKey)
			{
				return;
			}
			
			_steps = new Vector.<int>();
			_steps.push(2, 1, 0);
			
			(FlxG.state as Play).stopEffects();
			Global.hud.clock.pause();
			
			(Global.player.behaviors.getBehaviorByName("PrepareToEnterDoor") as PrepareToEnterDoor).door = this;
			Global.player.behaviors.switchBehavior("PrepareToEnterDoor");
		}
		
		public function get door():FlxSprite 
		{
			return _door;
		}
		
	}

}