package
{
	import flash.display.Sprite;
	
	public class Test extends Sprite
	{
		
		public function Test()
		{
			LevelAction.execute("testA()");
			LevelAction.execute("testNULL()");
			LevelAction.execute("testB(1,2,3)");
			LevelAction.execute(" testC ( 1 , 2 , 3 ) ");
			LevelAction.execute("testD(1, hello\\, world)");
			LevelAction.execute("    testE(1        , hello world ,   3      )");
			LevelAction.execute("testF(0x10)");
		}
	}
}