//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.starling.bundles.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;
	import robotlegs.starling.extensions.localEventMap.api.IEventMap;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Classic Robotlegs mediator implementation
	 *
	 * <p>Override initialize and destroy to hook into the mediator lifecycle.</p>
	 */
	public class Mediator implements IMediator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var eventMap:robotlegs.bender.extensions.localEventMap.api.IEventMap;

		[Inject]
		public var starlingEventMap:robotlegs.starling.extensions.localEventMap.api.IEventMap;

		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var starlingEventDispatcher:EventDispatcher;

		private var _viewComponent:Object;

		/**
		 * @private
		 */
		public function set viewComponent(view:Object):void
		{
			_viewComponent = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
		}

		/**
		 * Runs after the mediator has been destroyed.
		 * Cleans up listeners mapped through the local EventMap.
		 */
		public function postDestroy():void
		{
			eventMap.unmapListeners();
			starlingEventMap.unmapListeners();
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		/** Registers a listener for a Starling based event from the view. */
		protected function addViewListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			starlingEventMap.mapListener(EventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		/**
		 * Registers a listener for a context (framework) event via the appropriate channel depending on the Event class:
		 * <li>Registers with the injected <code>starling.events.EventDispatcher</code> when <code>eventClass</code> is <code>starling.events.Event</code> or subclass</li>
		 * <li>Otherwise, registers with the injected <code>flash.events.IEventDispatcher</code></li>
		 */
		protected function addContextListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			if (eventClass == starling.events.Event || inheritsFrom(eventClass, starling.events.Event))
				starlingEventMap.mapListener(starlingEventDispatcher, eventString, listener, eventClass);
			else
				eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
		}

		/** Unregisters a listener for a Starling based event from the view. */
		protected function removeViewListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			starlingEventMap.unmapListener(EventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		/**
		 * Unregisters a listener for a context (framework) event via the appropriate channel depending on the Event class:
		 * <li>Unregisters with the injected <code>starling.events.EventDispatcher</code> when <code>eventClass</code> is <code>starling.events.Event</code> or subclass</li>
		 * <li>Otherwise, unregisters with the injected <code>flash.events.IEventDispatcher</code></li>
		 */
		protected function removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			if (inheritsFrom(eventClass, starling.events.Event))
				starlingEventMap.unmapListener(starlingEventDispatcher, eventString, listener, eventClass);
			else
				eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
		}

		/** 
		 * Dispatches an event via the appropriate event dispatcher:
		 * <li>The injected <code>flash.events.IEventDispatcher</code> for <code>flash.events.Event</code> instances</li>
		 * <li>The injected <code>starling.events.EventDispatcher</li></code> for <code>starling.events.Event</code> instances</li>  
		 */
		protected function dispatch(event:Object):void
		{
			if (event is starling.events.Event)
				starlingEventDispatcher.dispatchEvent(event as starling.events.Event);
			else if (event is flash.events.Event && eventDispatcher.hasEventListener(event.type))
				eventDispatcher.dispatchEvent(event as flash.events.Event);
		}
		
		private function inheritsFrom(descendant:Class, ancestor:Class):Boolean
		{
			if (!descendant || !ancestor)
				return false;
			
			var superName:String;
			var ancestorClassName:String = getQualifiedClassName(ancestor);
			while (superName && superName != "Object") {
				superName = getQualifiedSuperclassName(descendant);
				if (superName == ancestorClassName)
					return true;
				descendant = Class(getDefinitionByName(superName));
			}
			return false;
		}
	}
}