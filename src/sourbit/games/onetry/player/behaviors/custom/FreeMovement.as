package sourbit.games.onetry.player.behaviors.custom
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import sourbit.games.onetry.player.behaviors.Behavior;
	
	public class FreeMovement extends Behavior
	{
		public var onDroppable:Boolean;
		
		public function FreeMovement()
		{
		}
		
		override public function start():void
		{
			super.start();
			
			if (!user.curAnim)
			{
				user.play("indle");
			}
		}
		
		override public function update():void
		{
			user.acceleration.y = Global.GRAVITY;
			user.velocity.x = 0;
			
			if (user.graceTimer > 0)
			{
				--user.graceTimer;
			}
			if (user.offLedgeTimer > 0)
			{
				--user.offLedgeTimer;
			}
			
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
			
			if (user.key("justPressed", user.keyMap.jump))
			{
				user.graceTimer = 6;
			}
			
			if (user.jumpTimer == -1 && user.onGround && !user.isTouching(FlxObject.FLOOR))
			{
				user.offLedgeTimer = 6;
			}
			
			user.onGround = user.isTouching(FlxObject.FLOOR);
			
			if (user.isTouching(FlxObject.FLOOR) || user.offLedgeTimer > 0)
			{
				if (user.graceTimer > 0)
				{
					user.jumpTimer = 0;
					FlxG.play(JumpSFX);
				}
			}
			
			if (user.key("pressed", user.keyMap.down) && onDroppable)
			{
				if (user.key("pressed", user.keyMap.jump))
				{
					user.y += 5;
					user.last.y = user.y;
					
					user.graceTimer = 0;
					user.offLedgeTimer = 0;
					user.jumpTimer = -1;
					
					onDroppable = false;
				}
			}
			else
			{
				if (user.key("pressed", user.keyMap.jump))
				{
					if (user.jumpTimer >= 0)
					{
						user.jumpTimer += FlxG.elapsed;
						if (user.jumpTimer > .25)
						{
							user.jumpTimer = -1;
						}
					}
				}
				else
				{
					user.jumpTimer = -1;
				}
			}
			
			if (user.jumpTimer > 0)
			{
				user.velocity.y = -(user.jumpSpeed + user.jumpMomentumY);
				user.velocity.x += user.jumpMomentumX;
			}
			else
			{
				user.jumpMomentumY = 0;
				user.jumpMomentumX = 0;
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
				
				if (user.velocity.y + 25 >= 0)
				{
					user.play("fallStart");
				}
			}
			else
			{
				if (user.velocity.x != 0)
				{
					user.play("walk");
				}
				else
				{
					user.play("idle");
				}
			}
			
			if (user.justTouched(FlxObject.FLOOR))
			{
				if (!user.curAnim || (user.curAnim.name == "fallLoopR" || user.curAnim.name == "fallLoopL" || user.curAnim.name == "fallStartR" || user.curAnim.name == "fallStartL"))
				{
					user.play("landing");
				}
			}
			
			if (user.height == user.crouchHeight)
			{
				user.height = user.standHeight;
				user.offset.y = user.standOffsetY;
				
				user.y -= (user.crouchOffsetY - user.standOffsetY);
			}
			
			onDroppable = false;
			super.update();
		}
	
	}

}