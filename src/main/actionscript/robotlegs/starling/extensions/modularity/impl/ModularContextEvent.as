package robotlegs.starling.extensions.modularity.impl
{
	import flash.utils.getQualifiedClassName;
	
	import robotlegs.bender.framework.api.IContext;
	
	import starling.events.Event;
	import starling.utils.StringUtil;

	public class ModularContextEvent extends Event
	{
		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/
		
		public static const CONTEXT_ADD:String = "contextAdd";
		
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/
		
		private var _context:IContext;
		
		/**
		 * The context associated with this event
		 */
		public function get context():IContext
		{
			return _context;
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Module Context Event
		 * @param type The event type
		 * @param context The associated context
		 */
		public function ModularContextEvent(type:String, context:IContext)
		{
			super(type, true, true);
			_context = context;
		}
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		override public function toString():String
		{
			return StringUtil.format("[{0} context={3} type=\"{1}\" bubbles={2}]",
				getQualifiedClassName(this).split("::").pop(), type, bubbles, context);
		}
	}
}