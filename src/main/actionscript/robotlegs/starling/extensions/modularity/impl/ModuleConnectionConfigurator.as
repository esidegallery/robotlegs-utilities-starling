package robotlegs.starling.extensions.modularity.impl
{
	import robotlegs.starling.extensions.eventDispatcher.impl.EventRelay;
	import robotlegs.starling.extensions.modularity.dsl.IModuleConnectionAction;

	import starling.events.EventDispatcher;

	/**
	 * @private
	 */
	public class ModuleConnectionConfigurator implements IModuleConnectionAction
	{
		
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private var _channelToLocalRelay:EventRelay;
		
		private var _localToChannelRelay:EventRelay;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		public function ModuleConnectionConfigurator(
			localDispatcher:EventDispatcher,
			channelDispatcher:EventDispatcher)
		{
			_localToChannelRelay = new EventRelay(localDispatcher, channelDispatcher).start();
			_channelToLocalRelay = new EventRelay(channelDispatcher, localDispatcher).start();
		}
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		public function relayEvent(eventType:String):IModuleConnectionAction
		{
			_localToChannelRelay.addType(eventType);
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function receiveEvent(eventType:String):IModuleConnectionAction
		{
			_channelToLocalRelay.addType(eventType);
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function suspend():void
		{
			_channelToLocalRelay.stop();
			_localToChannelRelay.stop();
		}
		
		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			_channelToLocalRelay.start();
			_localToChannelRelay.start();
		}
		
		/**
		 * @private
		 */
		public function destroy():void
		{
			_localToChannelRelay.stop();
			_localToChannelRelay = null;
			_channelToLocalRelay.stop();
			_channelToLocalRelay = null;
		}
	}
}