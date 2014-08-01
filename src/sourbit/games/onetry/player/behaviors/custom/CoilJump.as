package sourbit.games.onetry.player.behaviors.custom 
{
	import sourbit.games.onetry.player.behaviors.Behavior;
	import sourbit.games.onetry.props.Coil;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class CoilJump extends Behavior 
	{
		public var coil:Coil;
		
		public function CoilJump() {}
		
		
		override public function start():void 
		{
			super.start();
			
			chainBehavior = "FreeMovement";
			
			user.y = coil.y - user.height;
			user.velocity.y = -coil.impulse;
			user.jumpTimer = -1;
			
			FlxG.play(JumpSFX);
			FlxG.play(CoilSFX, .6);
		}
		
		override public function update():void 
		{
			user.acceleration.y = Global.GRAVITY;
			user.velocity.x = 0;
			
			if (user.key("pressed", user.keyMap.left))
			{
				user.velocity.x = -user.moveSpeed;
				user.facing = FlxObject.LEFT;
			}
			else if (user.key("pressed", user.keyMap.right))
			{
				user.velocity.x = user.moveSpeed;
				user.facing = FlxObject.RIGHT;
			}
			
			if (user.velocity.y > 0)
			{
				if (user.curAnim.name != "fallLoopR" && user.curAnim.name != "fallLoopL")
				{
					user.play("fallStart");
				}
				
				if (user.curAnim.name == "fallLoopR" && user.facing == FlxObject.LEFT)
				{
					user.play("fallLoop");
				}
				else if (user.curAnim.name == "fallLoopL" && user.facing == FlxObject.RIGHT)
				{
					user.play("fallLoop");
				}
			}
			else if (user.velocity.y < 0)
			{
				if (user.curAnim.name != "jumpLoopR" && user.curAnim.name != "jumpLoopL")
				{
					user.play("jumpStart");
				}
				
				if (user.curAnim.name == "jumpLoopR" && user.facing == FlxObject.LEFT)
				{
					user.play("jumpLoop");
				}
				else if (user.curAnim.name == "jumpLoopL" && user.facing == FlxObject.RIGHT)
				{
					user.play("jumpLoop");
				}
				
				if (user.velocity.y + 10 >= 0)
				{
					user.play("fallStart");
				}
			}
			
			if (user.justTouched(FlxObject.FLOOR))
			{
				user.play("landing");
				finish = true;
			}
			
			if (Math.abs(user.velocity.y) <= 10)
			{
				finish = true;
			}
			
			super.update();
		}
		
	}

}