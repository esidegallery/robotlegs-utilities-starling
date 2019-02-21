//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.starling.extensions.mediatorMap
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.starling.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.starling.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.starling.extensions.viewManager.api.IViewManager;

	/**
	 * This extension installs a shared IMediatorMap into the context
	 */
	public class MediatorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:IInjector;

		private var _mediatorMap:MediatorMap;

		private var _viewManager:IViewManager;
		
		private var _syncWithFeathers:Boolean;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Modularity
		 *
		 * @param synchronizeWithFeathersLifecycle Whether to listen for a view's FeathersEventType.INITIALIZE event
		 *                                         before initializing its mediator.
		 */
		public function MediatorMapExtension(syncWithFeathers:Boolean = true)
		{
			_syncWithFeathers = syncWithFeathers;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			context.beforeInitializing(beforeInitializing)
					.beforeDestroying(beforeDestroying)
					.whenDestroying(whenDestroying);
			_injector = context.injector;
//			_injector.map(IMediatorMap).toSingleton(MediatorMap);
			_injector.map(IMediatorMap).toValue(new MediatorMap(context, _syncWithFeathers));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function beforeInitializing():void
		{
			_mediatorMap = _injector.getInstance(IMediatorMap);
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.addViewHandler(_mediatorMap);
			}
		}

		private function beforeDestroying():void
		{
			_mediatorMap.unmediateAll();
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.removeViewHandler(_mediatorMap);
			}
		}

		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IMediatorMap))
			{
				_injector.unmap(IMediatorMap);
			}
		}
	}
}