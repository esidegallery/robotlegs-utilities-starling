package robotlegs.starling.extensions.modularity.impl
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.starling.extensions.modularity.api.IModuleConnector;
	import robotlegs.starling.extensions.modularity.dsl.IModuleConnectionAction;
	
	import starling.events.EventDispatcher;

	public class ModuleConnector implements IModuleConnector
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private var _rootInjector:IInjector;
		
		private var _localDispatcher:EventDispatcher;
		
		private var _configuratorsByChannel:Object = {};
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		public function ModuleConnector(context:IContext)
		{
			const injector:IInjector = context.injector;
			_rootInjector = getRootInjector(injector);
			_localDispatcher = injector.getInstance(EventDispatcher);
			context.whenDestroying(destroy);
		}
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		public function onChannel(channelId:String):IModuleConnectionAction
		{
			return getOrCreateConfigurator(channelId);
		}
		
		/**
		 * @inheritDoc
		 */
		public function onDefaultChannel():IModuleConnectionAction
		{
			return getOrCreateConfigurator('global');
		}
		
		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		
		private function destroy():void
		{
			for (var channelId:String in _configuratorsByChannel)
			{
				const configurator:ModuleConnectionConfigurator = _configuratorsByChannel[channelId];
				configurator.destroy();
				delete _configuratorsByChannel[channelId];
			}
			
			_configuratorsByChannel = null;
			_localDispatcher = null;
			_rootInjector = null;
		}
		
		private function getOrCreateConfigurator(channelId:String):ModuleConnectionConfigurator
		{
			return _configuratorsByChannel[channelId] ||= createConfigurator(channelId);
		}
		
		private function createConfigurator(channelId:String):ModuleConnectionConfigurator
		{
			if (!_rootInjector.hasMapping(EventDispatcher, channelId))
			{
				_rootInjector.map(EventDispatcher, channelId)
					.toValue(new EventDispatcher());
			}
			return new ModuleConnectionConfigurator(_localDispatcher, _rootInjector.getInstance(EventDispatcher, channelId));
		}
		
		private function getRootInjector(injector:IInjector):IInjector
		{
			while (injector.parent)
			{
				injector = injector.parent;
			}
			return injector;
		}
	}
}