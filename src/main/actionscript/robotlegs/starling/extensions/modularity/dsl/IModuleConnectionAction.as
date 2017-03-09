package robotlegs.starling.extensions.modularity.dsl
{
	/**
	 * @private
	 */
	public interface IModuleConnectionAction
	{
		function relayEvent(eventType:String):IModuleConnectionAction;
		
		function receiveEvent(eventType:String):IModuleConnectionAction;
		
		function suspend():void;
		
		function resume():void;
	}
}