package sourbit.games.onetry.player.behaviors.custom 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.player.behaviors.Behavior;
	
	public class Grabbed extends Behavior 
	{
		public var grabbedTo:Entity;
		public var grabbedAnchor:FlxPoint;
		
		public function Grabbed() 
		{
			chainBehavior = "FreeMovement";
			grabbedAnchor = new FlxPoint();
		}
		
		override public function update():void 
		{
			if (!user.grabbed && user.oldGrabbed)
			{
				finish = true;
			}
			
			user.velocity.x = 0;
			user.velocity.y = 0;
			user.acceleration.y = 0;
			
			user.y = grabbedAnchor.y; 
			user.last.y = user.y;
			
			user.x = grabbedAnchor.x;
			user.last.x =  user.x;
			
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
			
			user.play("grab");
			
			super.update();
		}
		
	}

}