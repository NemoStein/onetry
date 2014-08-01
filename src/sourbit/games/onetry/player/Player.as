package sourbit.games.onetry.player 
{
	import org.flixel.system.FlxAnim;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.player.behaviors.BehaviorManager;
	import sourbit.games.onetry.player.behaviors.custom.CoilJump;
	import sourbit.games.onetry.player.behaviors.custom.EnterLevel;
	import sourbit.games.onetry.player.behaviors.custom.FreeMovement;
	import sourbit.games.onetry.player.behaviors.custom.Grabbed;
	import sourbit.games.onetry.player.behaviors.custom.OnPlatform;
	import sourbit.games.onetry.player.behaviors.custom.PrepareToEnterDoor;
	import sourbit.games.onetry.player.behaviors.custom.TreadmillWalk;
	import org.flixel.FlxG;
	import sourbit.games.onetry.states.Play;
	
	public class Player extends Entity 
	{
		private var _behaviors:BehaviorManager;
		private var _playedThisFrame:Boolean;
		
		public var moveSpeed:int = 90;
		public var jumpSpeed:int = 135;
		
		public var jumpMomentumY:int = 0;
		public var jumpMomentumX:int = 0;
		
		public var maxVelocityX:int = 600;
		public var maxVelocityY:int = 900;
		
		public var graceTimer:Number = 0;
		public var offLedgeTimer:Number = 0;
		public var jumpTimer:Number = 0;
		
		public var onGround:Boolean = true;
		
		public var grabbed:Boolean;
		public var oldGrabbed:Boolean;
		
		public var standHeight:int;
		public var crouchHeight:int;
		
		public var standOffsetY:int;
		public var crouchOffsetY:int;
		
		public var keyMap:Object =
		{
			left :["LEFT", "A"],
			right :["RIGHT", "D"],
			down:["DOWN", "S"],
			jump :["UP", "W", "SPACE", "C"],
			action : ["X", "SHIFT"],
			any : ["LEFT","A","RIGHT","D","UP","W","SPACE","X","SHIFT","Z","C"]
		};
		
		public function Player(x:int,y:int) 
		{
			super( -1, x, y);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			_behaviors = new BehaviorManager(this);
			_behaviors.addBehavior( new FreeMovement());
			_behaviors.addBehavior( new CoilJump());
			_behaviors.addBehavior( new TreadmillWalk());
			_behaviors.addBehavior( new OnPlatform());
			_behaviors.addBehavior( new PrepareToEnterDoor());
			_behaviors.addBehavior( new EnterLevel());
			_behaviors.addBehavior( new Grabbed());
			
			_behaviors.switchBehavior("FreeMovement");
			
			maxVelocity.x = maxVelocityX;
			maxVelocity.y = maxVelocityY;
		}
		
		override protected function checkGraphic():void 
		{
			loadGraphic(Global.assetsHolder[Assets.PLAYER], true, false, 18, 30);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			width = 8;
			height = 24;
			
			offset.x = 5;
			offset.y = 2;
			
			standHeight = 24;
			crouchHeight = 16;
			
			standOffsetY = 2;
			crouchOffsetY = 10;
		}
		
		override protected function checkAnimation():void 
		{
			addAnimation("walk", [2, 3, 4, 5, 6, 7, 8, 10, 11], 18, true);
			addAnimation("jumpStart", [12], 32, false);
			addAnimation("jumpLoop", [13, 14, 15, 16], 10, true);
			addAnimation("fallStart", [17, 18, 19], 10);
			addAnimation("fallLoop", [20, 21, 22, 23], 10, true);
			addAnimation("landing", [12,12], 10);
			addAnimation("idle", [0, 1], 3.5, true);
			addAnimation("grab", [24, 25, 26, 27], 10, true);
			
			addAnimationCallback(animationCallback);
		}
		
		override public function addAnimation(Name:String, Frames:Array, FrameRate:Number = 0, Looped:Boolean = true):void 
		{
			super.addAnimation(Name + "R", Frames, FrameRate, Looped);
			
			var offesetFrames:Array = Frames.map(function(item:*, index:int, array:Array):int
			{
				return item + 28;
			});
			
			super.addAnimation(Name + "L", offesetFrames, FrameRate, Looped);
		}
		
		override public function play(AnimName:String, Force:Boolean = false):void 
		{
			super.play(AnimName = AnimName.concat((facing == LEFT) ? "L" : "R"), Force);
		}
		
		private function animationCallback(name:String, frame:uint, index:uint):void
		{
			if (name == null) return;
			
			var sulfix:String = name.substr(name.length - 1, 1);
			var newName:String = name.substr(0, name.length - 1);
			
			if (newName == "walk")
			{
				if (frame == 3 || frame == 8)
				{
					if (!_playedThisFrame)
					{
						_playedThisFrame = true;
						FlxG.play(StepSFX, .5);
					}
				}
				else
				{
					_playedThisFrame = false;
				}
			}
			
			if (newName == "jumpStart")
			{
				if (finished)
				{
					play("jumpLoop");
				}
			}
			else if(newName == "fallStart")
			{
				if (finished)
				{
					play("fallLoop");
				}
			}
		}
		
		public function key(fun:String, keys:Array):Boolean
		{
			for each(var str:String in keys)
			{
				if (FlxG.keys[fun](str))
				{
					return true;
				}
			}
			
			return false;
		}
		
		override public function update():void
		{
			if (key("pressed", keyMap.any) && behaviors.currentBehavior.name != "EnterLevel")
			{
				(FlxG.state as Play).start();
			}
			
			super.update();
			_behaviors.update();
			
			oldGrabbed = grabbed;
			grabbed = key("pressed", keyMap.action);
		}
		
		public function get behaviors():BehaviorManager 
		{
			return _behaviors;
		}
		
	}

}