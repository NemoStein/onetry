package sourbit.games.onetry.player.behaviors.custom 
{
	import sourbit.games.onetry.player.behaviors.Behavior;
	import sourbit.games.onetry.props.treadmill.Treadmill;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class TreadmillWalk extends Behavior 
	{
		public var treadmill:Treadmill;
		public var direction:int;
		public var force:int;
		public var grabbed:Boolean;
		
		private var _walkPressed:Boolean;
		private var _dummy:FlxObject;
		
		public function TreadmillWalk() { }
		
		override public function start():void 
		{
			super.start();
			
			chainBehavior = "FreeMovement";
			
			direction = treadmill.direction == Treadmill.LEFT ? -1 : 1;
			force = treadmill.speed;
			
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
				_walkPressed = false;
				
				if (user.key("pressed", user.keyMap.left))
				{
					user.velocity.x = -user.moveSpeed;
					user.facing = FlxObject.LEFT;
					
					_walkPressed = true;
				}
				else if (user.key("pressed", user.keyMap.right))
				{
					user.velocity.x = user.moveSpeed;
					user.facing = FlxObject.RIGHT;
					
					_walkPressed = true;
				}
				
				user.velocity.x += (force * direction);
				user.jumpMomentumX = (force * direction) / 2;
				
				if (user.y + user.height < treadmill.y - 5 || user.y + user.height > treadmill.y + treadmill.height || user.x + user.width <= treadmill.x || user.x >= treadmill.x + treadmill.width)
				{
					end();
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
				
				if (user.key("pressed", user.keyMap.down))
				{
					if (user.key("pressed", user.keyMap.jump))
					{
						if (Global.groundMap.getTile( user.x / Global.TILE_SIDE, (treadmill.y / Global.TILE_SIDE) + 1 ) == 0)
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
						}
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
					
					if (!_dummy.overlapsAt( user.x, user.y - 1, Global.groundMap))
					{
						if (user.jumpTimer > 0)
						{	
							user.velocity.y = -user.jumpSpeed;
						}
					}
				}
			}
			else
			{
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
					user.velocity.y = -user.jumpSpeed;
					finish = true;
				}
				
				if ( Math.abs((treadmill.y + treadmill.height - 2) - user.y) > 16)
				{
					grabbed = false;
					end();
					return;
				}
				
				if (user.x + user.width <= treadmill.x + 14 || user.x + user.width >= treadmill.x + treadmill.width - 4)
				{
					user.y += 4;
					user.last.y = user.y;
					user.jumpTimer = -1;
					user.velocity.y = -1;
					
					grabbed = false;
					end();
					return;
				}
				
				user.y = treadmill.y + treadmill.height - 2;
				user.last.y = user.y;
				
				user.velocity.x += (force * (direction * -1));
			}
			
			if (!grabbed)
			{
				if (user.velocity.y > 0)
				{
					if (user.curAnim.name != "fallLoopR" && user.curAnim.name != "fallLoopL" )
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
				else if (user.velocity.x != 0)
				{
					if (_walkPressed)
					{
						user.play("walk");
					}
					else
					{
						user.play("idle");
					}
					
				}
				else
				{
					user.play("idle");
				}
				
				if (user.justTouched(FlxObject.FLOOR))
				{
					user.play("landing");
				}
				
				var offset:Number = user.velocity.x * FlxG.elapsed;
				if(user.curAnim.name == "walkR" || user.curAnim.name == "walkL")
				{
					if (!_dummy.overlapsAt( user.x, user.y - 1, Global.groundMap))
					{
						if (user.height == user.crouchHeight)
						{
							user.height = user.standHeight;
							user.offset.y = user.standOffsetY;
							
							user.y -= (user.crouchOffsetY - user.standOffsetY);
							user.last.y = user.y;
						}
					}
					else
					{
						user.play("idle");
						user.velocity.x = (force * direction);
					}
				}
				if (user.curAnim.name == "idleL" || user.curAnim.name == "idleR")
				{
					if (!_dummy.overlapsAt( user.x + offset, user.y + 8, Global.groundMap))
					{
						if (user.height == user.standHeight)
						{
							user.height = user.crouchHeight;
							user.offset.y = user.crouchOffsetY;
							
							user.y += (user.crouchOffsetY - user.standOffsetY);
							user.last.y = user.y;
						}
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