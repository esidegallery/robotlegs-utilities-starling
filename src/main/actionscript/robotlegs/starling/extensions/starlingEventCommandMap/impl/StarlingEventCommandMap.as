package robotlegs.starling.extensions.starlingEventCommandMap.impl
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.starling.extensions.starlingEventCommandMap.api.IStarlingEventCommandMap;
	
	import starling.events.EventDispatcher;
	
	public class StarlingEventCommandMap implements IStarlingEventCommandMap
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private const _mappingProcessors:Array = [];
		
		private var _injector:IInjector;
		
		private var _dispatcher:EventDispatcher;
		
		private var _triggerMap:CommandTriggerMap;
		
		private var _logger:ILogger;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * @private
		 */
		public function StarlingEventCommandMap(context:IContext, dispatcher:EventDispatcher)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			_dispatcher = dispatcher;
			_triggerMap = new CommandTriggerMap(getKey, createTrigger);
		}
		
		public function map(type:String, eventClass:Class=null):ICommandMapper
		{
			var trigger:Object = getTrigger(type, eventClass);
			return trigger.createMapper();
		}
		
		public function unmap(type:String, eventClass:Class=null):ICommandUnmapper
		{
			return getTrigger(type, eventClass).createMapper();
		}
		
		public function addMappingProcessor(handler:Function):IEventCommandMap
		{
			if (_mappingProcessors.indexOf(handler) == -1)
				_mappingProcessors.push(handler);
			return this;
		}
		
		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		
		private function getKey(type:String, eventClass:Class):String
		{
			return type + eventClass;
		}
		
		private function getTrigger(type:String, eventClass:Class):StarlingEventCommandTrigger
		{
			return _triggerMap.getTrigger(type, eventClass) as StarlingEventCommandTrigger;
		}
		
		private function createTrigger(type:String, eventClass:Class):StarlingEventCommandTrigger
		{
			return new StarlingEventCommandTrigger(_injector, _dispatcher, type, eventClass, _mappingProcessors, _logger);
		}
	}
}