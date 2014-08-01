package sourbit.games.onetry.player.behaviors 
{
	import sourbit.games.onetry.player.Player;
	import flash.utils.describeType;
	
	public class BehaviorManager 
	{
		private var _behaviors:Object;
		
		private var _requestBehavior:Behavior;
		private var _chainBehaviorName:String;
		
		public var currentBehavior:Behavior;
		public var lastBehavior:Behavior;
		
		private var _user:Player;
		
		public function BehaviorManager(user:Player) 
		{
			_behaviors = new Object();
			_user = user;
		}
		
		public function update():void
		{
			if (currentBehavior && currentBehavior.active)
			{
				currentBehavior.update();
			}
			
			if (_requestBehavior && _requestBehavior != currentBehavior)
			{
				lastBehavior = currentBehavior;
				currentBehavior = _requestBehavior;
				
				_requestBehavior = null;
				currentBehavior.start();
			}
		}
		
		public function addBehavior(behavior:Behavior):void
		{
			var name:String = String(describeType(behavior).@name);
			var pointsIndex:int = name.lastIndexOf(":");
			name = name.substr(pointsIndex + 1);
			
			behavior.user = _user;
			behavior.manager = this;
			behavior.name = name;
			_behaviors[name] = behavior;
		}
		
		public function getBehaviorByName(name:String):Behavior
		{
			return _behaviors[name];
		}
		
		public function endBehavior():void
		{
			if (_chainBehaviorName != "")
			{
				switchBehavior(_chainBehaviorName);
			}
		}
		
		public function switchBehavior(nextBehaviorName:String):void
		{
			if (!currentBehavior)
			{
				_requestBehavior = getBehaviorByName(nextBehaviorName);
				return;
			}
			
			if (currentBehavior != getBehaviorByName(nextBehaviorName))
			{
				_requestBehavior = getBehaviorByName(nextBehaviorName);
			}
		}
		
		public function chainBehavior(behaviorName:String):void
		{
			_chainBehaviorName = behaviorName;
		}
		
	}

}