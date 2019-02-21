//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.starling.extensions.viewManager.impl
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * @private
	 */
	public class StageObserver
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _registry:ContainerRegistry;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function StageObserver(containerRegistry:ContainerRegistry)
		{
			_registry = containerRegistry;
			// We only care about roots
			_registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
			_registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
			// We might have arrived late on the scene
			for each (var binding:ContainerBinding in _registry.rootBindings)
			{
				addRootListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function destroy():void
		{
			_registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
			_registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
			for each (var binding:ContainerBinding in _registry.rootBindings)
			{
				removeRootListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onRootContainerAdd(event:ContainerRegistryEvent):void
		{
			addRootListener(event.container);
		}

		private function onRootContainerRemove(event:ContainerRegistryEvent):void
		{
			removeRootListener(event.container);
		}

		private function addRootListener(container:DisplayObjectContainer):void
		{
			// It is the ADDED event that bubbles, not the ADDED_TO_STAGE event.
			container.addEventListener(Event.ADDED, onViewAdded);
			container.addEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
		}

		private function removeRootListener(container:DisplayObjectContainer):void
		{
			container.removeEventListener(Event.ADDED, onViewAdded);
			container.removeEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
		}

		private function onViewAdded(event:Event):void
		{
			if (event.target is DisplayObject)
			{
				processView(event.target as DisplayObject);
			}
		}
		
		private function processView(view:DisplayObject):void
		{
			const type:Class = view['constructor'];
			
			// Walk upwards from the nearest binding
			var binding:ContainerBinding = _registry.findParentBinding(view);
			while (binding)
			{
				binding.handleView(view, type);
				binding = binding.parent;
			}
			
			// We need to check the view's children in the same way
			// as the ADDED_TO_STAGE event that is broadcast from them doesn't bubble:
			var container:DisplayObjectContainer = view as DisplayObjectContainer;
			if (container)
			{
				var numChildren:int = container.numChildren;
				for (var i:int = 0; i < numChildren; ++i)
				{
					processView(container.getChildAt(i));
				}
			}
		}
		
		private function onContainerRootAddedToStage(event:Event):void
		{
			const container:DisplayObjectContainer = event.target as DisplayObjectContainer;
			container.removeEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
			const type:Class = container['constructor'];
			const binding:ContainerBinding = _registry.getBinding(container);
			binding.handleView(container, type);
		}
	}
}