package sourbit.games.onetry.props
{
	import sourbit.games.onetry.entities.Entity;
	
	public class Jelly extends Entity
	{
		private var _basePRD:Number = 0.08474; // 25
		private var _chance:Number = _basePRD;
		
		public function Jelly(id:int, x:int, y:int)
		{
			// ALERT: Magic numbers are alignment of the sprite
			super(id, x + 1, y - 4);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			play("idle");
		}
		
		override protected function checkGraphic():void
		{
			loadGraphic(Global.assetsHolder[Assets.JELLY], true, true, 30, 20);
		}
		
		override protected function checkAnimation():void
		{
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 4, 3, 2, 1], 16, true);
			addAnimation("walk", [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 16,false);
			
			addAnimationCallback(chainAnimations);
		}
		
		private function changeAnimation(changeFacing:Boolean=true):void
		{
			if (changeFacing)
			{
				facing = facing == LEFT? RIGHT : LEFT;
			}
			
			play(_curAnim.name == "idle" ? "walk" : "idle");
			
		}
		
		private function chainAnimations(name:String, frame:uint, index:uint):void
		{
			if (name == "idle" && frame == 2)
			{
				if (getChance())
				{
					changeAnimation(false);
				}
			}
			
			if (name == "walk" && finished)
			{
				changeAnimation(true);
			}
		}
		
		private function getChance():Boolean
		{
			
			if (Math.random() < _chance)
			{
				_chance = _basePRD;
				return true;
			}
			else
			{
				_chance += _basePRD;
				return false;
			}
		}
	}
}