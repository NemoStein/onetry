package sourbit.games.onetry.props 
{
	import sourbit.games.onetry.entities.Entity;
	
	public class Key extends Entity 
	{
		public function Key(id:int,x:int,y:int) 
		{
			super(id, x, y);
			
			play("spin");
		}
		
		override protected function checkGraphic():void 
		{
			loadGraphic(Global.assetsHolder[Assets.KEY], true, false, Global.TILE_SIDE, 12);
			
			width = 14;
			height = 10;
			
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
		}
		
		override protected function checkAnimation():void 
		{
			addAnimation("spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 12, 11, 10, 9, 8, 14, 6, 15, 4, 3, 2, 1], 16, true);
		}
	}	
}