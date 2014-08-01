package sourbit.games.onetry.player.behaviors.custom 
{
	import sourbit.games.onetry.player.behaviors.Behavior;
	import sourbit.games.onetry.props.MovingPlatform;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class OnPlatform extends Behavior 
	{
		public var platform:MovingPlatform;
		public var grabbed:Boolean;
		
		private var _dummy:FlxObject;
		
		public function OnPlatform() {}
		
		override public function start():void 
		{
			super.start();
			
			chainBehavior = "FreeMovement";
			
			_dummy = new FlxObject(0, 0, 8, 16);
		}
		
		override public function update():void 
		{
			if (grabbed && !user.grabbed && user.oldGrabbed)
			{
				end();
				grabbed = false;
				return;
			}
			
			if (!grabbed)
			{
				user.acceleration.y = Global.GRAVITY;
			}
			else
			{
				user.acceleration.y = 0;
				user.velocity.y = 0;
			}
			
			user.velocity.x = 0;
			
			if (user.graceTimer > 0)
			{
				--user.graceTimer;
			}
			if (user.offLedgeTimer > 0)
			{
				--user.offLedgeTimer;
			}
			
			if (!grabbed)
			{
				if (Math.abs((platform.y - user.height) - user.y) > 16)
				{
					grabbed = false;
					end();
					return;
				}
				
				user.y = platform.y - user.height;
				user.last.y = user.y;
				
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
				
				if (user.key("justPressed", user.keyMap.jump) && !user.overlapsAt(user.x, user.y - 1, Global.groundMap))
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
						finish = true;
						FlxG.play(JumpSFX);
					}
				}
				
				if (user.overlapsAt(user.x + 1, user.y, Global.groundMap))
				{
					user.x -= 1;
				}
				else if (user.overlapsAt(user.x - 1, user.y, Global.groundMap))
				{
					user.x += 1;
				}
				
				if (user.key("pressed", user.keyMap.down))
				{
					if (user.key("pressed", user.keyMap.jump))
					{
						if (user.height == user.crouchHeight)
						{
							user.height = user.standHeight;
							user.offset.y = user.standOffsetY;
						}
						
						user.y += 5;
						user.last.y = user.y;
						
						user.graceTimer = 0;
						user.offLedgeTimer = 0;
						user.jumpTimer = -1;
						
						end();
						return;
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
					
					if (user.jumpTimer > 0)
					{
						user.jumpMomentumY = platform.velocity.y < 0 ? (platform.velocity.y/2) *-1 : 0;
						user.velocity.y = -(user.jumpSpeed + user.jumpMomentumY);
						
						finish = true;
					}
				}
			}
			else
			{
				user.onGround = user.isTouching(FlxObject.FLOOR);
				
				if (user.key("pressed", user.keyMap.left))
				{
					user.facing = FlxObject.LEFT;
				}
				else if (user.key("pressed", user.keyMap.right))
				{
					user.facing = FlxObject.RIGHT;
				}
				
				if (user.key("justPressed", user.keyMap.jump))
				{
					user.jumpTimer = 0;
					user.velocity.y = -(user.jumpSpeed + user.jumpMomentumY);
					finish = true;
				}
				
				if (user.onGround || user.overlapsAt(user.x, user.y, Global.groundMap))
				{
					user.grabbed = false;
					user.oldGrabbed = false;
					grabbed = false;
					
					end();
					return;
				}
				
				if (Math.abs((platform.y + platform.height - 2) - user.y) > 16)
				{
					grabbed = false;
					end();
					return;
				}
				
				user.y = platform.y + platform.height - 2;
				user.last.y = user.y;
				
				user.velocity.x += platform.velocity.x;
			}
			
			if (user.x > platform.x + platform.width || user.x + user.width < platform.x)
			{
				grabbed = false;
				end();
			}
			
			if (!grabbed)
			{
				if(user.velocity.x != 0)
				{
					user.play("walk");
				}
				else
				{
					user.play("idle");
				}
				
				if (user.curAnim.name == "idleL" || user.curAnim.name == "idleR")
				{
					if (user.height == user.standHeight)
					{
						user.height = user.crouchHeight;
						user.offset.y = user.crouchOffsetY;
						
						user.y += user.crouchOffsetY - user.standOffsetY;
					}
				}
				else
				{
					if (!user.overlapsAt( user.x, user.y - 1, Global.groundMap, true))
					{
						if (user.height == user.crouchHeight)
						{
							user.height = user.standHeight;
							user.offset.y = user.standOffsetY;
							
							user.y -= user.crouchOffsetY - user.standOffsetY;
							user.velocity.x = 0;
						}
					}
					else
					{
						user.play("idle");
						user.velocity.x = 0;
					}
				}
			}
			else
			{
				user.play("grab");
			}
			
			super.update();
		}
		
	}

}