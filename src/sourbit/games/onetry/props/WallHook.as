package sourbit.games.onetry.props 
{
	import sourbit.games.onetry.entities.Entity;
	
	public class WallHook extends Entity 
	{
		
		public function WallHook(id:int, x:int, y:int)
		{
			super(id, x, y);
		}
		
		override protected function initialize():void 
		{
			immovable = true;
			
			super.initialize();
		}
		
		override protected function checkGraphic():void 
		{
			loadGraphic(Global.assetsHolder[Assets.WALL_HOOK]);
			
			width = 4;
			height = 4;
			
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
		}
	}

}