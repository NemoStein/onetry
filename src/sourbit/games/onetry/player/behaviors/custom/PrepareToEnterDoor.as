package sourbit.games.onetry.player.behaviors.custom 
{
	import sourbit.games.onetry.player.behaviors.Behavior;
	import sourbit.games.onetry.props.door.Door;
	import org.flixel.FlxObject;
	
	public class PrepareToEnterDoor extends Behavior 
	{
		private var _moveSpeed:int = 125;
		public var door:Door;
		
		public function PrepareToEnterDoor() 
		{
		}
		
		override public function start():void 
		{
			super.start();
		}
		
		override public function update():void 
		{
			user.acceleration.y = Global.GRAVITY;
			user.velocity.x = 0;
			
			if (user.x + user.width < door.x + 10 )
			{
				user.velocity.x = user.moveSpeed/2;
				user.facing = FlxObject.RIGHT;
			}
			else if (user.x > door.x + 22)
			{
				user.velocity.x = -user.moveSpeed/2;
				user.facing = FlxObject.LEFT;
			}
			else
			{
				end();
				Global.player.exists = false;
			}
			
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
			else
			{
				if(user.velocity.x != 0)
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
				user.play("landing");
			}
			
			super.update();
		}
	}

}