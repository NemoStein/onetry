package sourbit.games.onetry.props.switches 
{
	import sourbit.games.onetry.entities.Entity;
	
	public interface Wired 
	{
		function makeConnection(on:Boolean):void
		
		function getEntity():Entity
		
		function get totalConnections():int
		function set totalConnections(value:int):void
		
		function get currentConnected():int
		function set currentConnected(value:int):void
		
		function activate():void
		function deactivate():void
		
		function toggle():void
	}
}