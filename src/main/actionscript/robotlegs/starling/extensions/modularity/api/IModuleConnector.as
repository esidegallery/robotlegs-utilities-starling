package robotlegs.starling.extensions.modularity.api
{
	import robotlegs.starling.extensions.modularity.dsl.IModuleConnectionAction;

	/**
	 * Creates event relays between modules
	 */
	public interface IModuleConnector
	{
		/**
		 * Connects to a specified channel
		 * @param channelId The channel Id
		 * @return Configurator
		 */
		function onChannel(channelId:String):IModuleConnectionAction;
		
		/**
		 * Connects to the default channel
		 * @return Configurator
		 */
		function onDefaultChannel():IModuleConnectionAction;
	}
}