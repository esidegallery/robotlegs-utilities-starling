package robotlegs.starling.extensions.starlingEventCommandMap
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.starling.extensions.starlingEventCommandMap.api.IStarlingEventCommandMap;
	import robotlegs.starling.extensions.starlingEventCommandMap.impl.StarlingEventCommandMap;

	import starling.events.EventDispatcher;
	
	public class StarlingEventCommandMapExtension implements IExtension
	{
		public function extend(context:IContext):void
		{
			context.injector.map(IStarlingEventCommandMap).toSingleton(StarlingEventCommandMap);
			context.injector.map(EventDispatcher).asSingleton();
		}
	}
}