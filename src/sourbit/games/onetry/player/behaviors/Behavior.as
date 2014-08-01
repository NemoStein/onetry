package sourbit.games.onetry.player.behaviors 
{
	import sourbit.games.onetry.player.Player;
	
	public class Behavior 
	{
		public var name:String;
		
		public var finish:Boolean;
		public var active:Boolean;
		
		public var user:Player;
		public var manager:BehaviorManager;
		public var chainBehavior:String="";
		
		public function Behavior() 
		{
			
		}
		
		public function update():void
		{
			if (finish)
			{
				end();
			}
		}
		
		public function start():void
		{
			finish = false;
			active = true;
		}
		
		public function end():void
		{
			if (chainBehavior != "")
			{
				manager.chainBehavior(chainBehavior);
			}
			
			manager.endBehavior();
		}
		
	}

}