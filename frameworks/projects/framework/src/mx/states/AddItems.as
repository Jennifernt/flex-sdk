////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2007 Adobe Systems Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
//  AdobePatentID="B770"
//
////////////////////////////////////////////////////////////////////////////////

package mx.states 
{
import flash.display.DisplayObject;

import mx.collections.IList;
import mx.core.ContainerCreationPolicy;
import mx.core.IChildList;
import mx.core.IDeferredInstance;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

[DefaultProperty("itemsFactory")]

/**
 *  Documentation is not currently available.
 */
public class AddItems extends OverrideBase implements IOverride
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

	/**
	 *  Documentation is not currently available.
	 */
    public static const FIRST:String = "first";

	/**
	 *  Documentation is not currently available.
	 */
    public static const LAST:String = "last";

	/**
	 *  Documentation is not currently available.
	 */
    public static const BEFORE:String = "before";

	/**
	 *  Documentation is not currently available.
	 */
    public static const AFTER:String = "after";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
	 *  Constructor.
	 */
	public function AddItems()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var added:Boolean = false;

    /**
     *  @private
     */
    private var startIndex:int;
    
    /**
     *  @private
     */
    private var numAdded:int;

    /**
     *  @private
     */
    private var instanceCreated:Boolean = false;
    

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  creationPolicy
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the creationPolicy property.
     */
    private var _creationPolicy:String = ContainerCreationPolicy.AUTO;

    [Inspectable(category="General")]

    /**
     *  The creation policy for the items.
     *  This property determines when the <code>itemsFactory</code> will create 
     *  the instance of the items.
     *  Flex uses this property only if you specify an <code>itemsFactory</code> property.
     *  The following values are valid:
     * 
     *  <p></p>
     * <table class="innertable">
     *     <tr><th>Value</th><th>Meaning</th></tr>
     *     <tr><td><code>auto</code></td><td>(default)Create the instance the 
     *         first time it is needed.</td></tr>
     *     <tr><td><code>all</code></td><td>Create the instance when the 
     *         application started up.</td></tr>
     *     <tr><td><code>none</code></td><td>Do not automatically create the instance. 
     *         You must call the <code>createInstance()</code> method to create 
     *         the instance.</td></tr>
     * </table>
     *
     *  @default "auto"
     */
    public function get creationPolicy():String
    {
        return _creationPolicy;
    }

    /**
     *  @private
     */
    public function set creationPolicy(value:String):void
    {
        _creationPolicy = value;

        if (_creationPolicy == ContainerCreationPolicy.ALL)
            createInstance();
    }

    //------------------------------------
    //  destination
    //------------------------------------

    /**
     *  The object relative to which the child is added. This property is used
     *  in conjunction with the <code>position</code> property. 
     *  This property is optional; if
     *  you omit it, Flex uses the immediate parent of the <code>State</code>
     *  object, that is, the component that has the <code>states</code>
     *  property, or <code>&lt;mx:states&gt;</code>tag that specifies the State
     *  object.
     */
    public var destination:Object;
    
    //------------------------------------
    //  items
    //------------------------------------

    /**
     *  @private
     *  Storage for the items property
     */
    private var _items:*;

    [Inspectable(category="General")]

    /**
     *
     *  The items to be added.
     *  If you set this property, the items are created at app startup.
     *  Setting this property is equivalent to setting a <code>itemsFactory</code>
     *  property with a <code>creationPolicy</code> of <code>"all"</code>.
     *
     *  <p>Do not set this property if you set the <code>itemsFactory</code>
     *  property.</p>
     */
    public function get items():*
    {
        if (!_items && creationPolicy != ContainerCreationPolicy.NONE)
            createInstance();

        return _items;
    }

    /**
     *  @private
     */
    public function set items(value:*):void
    {
        _items = value;
    }

    //------------------------------------
    //  itemsFactory
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the itemsFactory property.
     */
    private var _itemsFactory:IDeferredInstance;

    [Inspectable(category="General")]

    /**
     *
     * The factory that creates the items. 
     *
     *  <p>If you set this property, the items are instantiated at the time
     *  determined by the <code>creationPolicy</code> property.</p>
     *  
     *  <p>Do not set this property if you set the <code>items</code>
     *  property.
     *  This propety is the <code>AddItems</code> class default property.
     *  Setting this property with a <code>creationPolicy</code> of "all"
     *  is equivalent to setting a <code>items</code> property.</p>
     */
    public function get itemsFactory():IDeferredInstance
    {
        return _itemsFactory;
    }

    /**
     *  @private
     */
    public function set itemsFactory(value:IDeferredInstance):void
    {
        _itemsFactory = value;

        if (creationPolicy == ContainerCreationPolicy.ALL)
            createInstance();
    }

    //------------------------------------
    //  position
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  The position of the child in the display list, relative to the
     *  object specified by the <code>relativeTo</code> property.
     *
     *  @default AddItems.LAST
     */
    public var position:String = AddItems.LAST;

    //------------------------------------
    //  isStyle
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  Denotes whether or not the collection represented by the 
     *  target property is a style.
     *
     *  @default false
     */
    public var isStyle:Boolean = false;
    
    //------------------------------------
    //  isArray
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  Denotes whether or not the collection represented by the 
     *  target property is to be treated as a single array instance
     *  instead of a collection of items (the default).
     *
     *  @default false
     */
    public var isArray:Boolean = false;
    
    //------------------------------------
    //  propertyName
    //------------------------------------
    
    [Inspectable(category="General")]

    /**
     *  The name of the Array property that is being modified. If the <code>destination</code>
     *  property is a Group or Container, this property is optional. If not defined, the
     *  items will be added as children of the Group/Container.
     */
    public var propertyName:String;
    
    //------------------------------------
    //  relativeTo
    //------------------------------------
    
    [Inspectable(category="General")]

    /**
     *  The object relative to which the child is added. This property is only
     *  used when the <code>position</code> property is <code>AddItems.BEFORE</code>
     *  or <code>AddItems.AFTER</code>. 
     */
    public var relativeTo:Object;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates the items instance from the factory.
     *  You must use this method only if you specify a <code>targetItems</code>
     *  property and a <code>creationPolicy</code> value of <code>"none"</code>.
     *  Flex automatically calls this method if the <code>creationPolicy</code>
     *  property value is <code>"auto"</code> or <code>"all"</code>.
     *  If you call this method multiple times, the items instance is
     *  created only on the first call.
     */
    public function createInstance():void
    {
        if (!instanceCreated && !_items && itemsFactory)
        {
            instanceCreated = true;
            items = itemsFactory.getInstance();
        }
    }

    /**
     *  @inheritDoc
     */
    public function initialize():void
    {
        if (creationPolicy == ContainerCreationPolicy.AUTO)
            createInstance();
    }

    /**
     *  @inheritDoc
     */
    public function apply(parent:UIComponent):void
    {
        var dest:* = destination = getOverrideContext(destination, parent);
        var localItems:Array;
        
        // Coerce to array if not already an array, or we wish
        // to treat the array as *the* item to add (isArray == true)
        if (items is Array && !isArray)
            localItems = items;
        else
            localItems = [items];
        
        switch (position)
        {
            case FIRST:
                startIndex = 0;
                break;
            case LAST:
                startIndex = -1;
                break;
            case BEFORE:
                startIndex = getRelatedIndex(parent, dest);
                break;
            case AFTER:
                startIndex = getRelatedIndex(parent, dest) + 1;
                break;
        }    
        
        if ( (propertyName == null || propertyName == "mxmlContent") && (dest is IVisualElementContainer))
        {
            addItemsToContentHolder(dest as IVisualElementContainer, localItems);
        }
        else if (propertyName == null && dest is IChildList)
        {
            addItemsToContainer(dest as IChildList, localItems);
        }
        else if (propertyName != null && !isStyle && dest[propertyName] is IList)
        {
            addItemsToIList(dest[propertyName], localItems);
        }
        else
        {
            addItemsToArray(dest, propertyName, localItems);
        }
        
        added = true;
        numAdded = localItems.length;
    }

    /**
     *  @inheritDoc
     */
    public function remove(parent:UIComponent):void
    {
        var dest:* = getOverrideContext(destination, parent);
        var localItems:Array;
        var i:int;
        
        if (!added)
            return;
                    
        // Coerce to array if not already an array, or we wish
        // to treat the array as *the* item to add (isArray == true)
        if (items is Array && !isArray)
            localItems = items;
        else
            localItems = [items];
             
        if ((propertyName == null || propertyName == "mxmlContent") && (dest is IVisualElementContainer))
        {
            for (i = 0; i < numAdded; i++)
                IVisualElementContainer(dest).removeElementAt(startIndex);
        }
        else if (propertyName == null && dest is IChildList)
        {
            for (i = 0; i < numAdded; i++)
                IChildList(dest).removeChildAt(startIndex);
        }
        else if (propertyName != null && !isStyle && dest[propertyName] is IList)
        {
            removeItemsFromIList(dest[propertyName] as IList);
        }
        else
        {
            var tempArray:Array = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
                
            if (numAdded < tempArray.length) 
            {
                tempArray.splice(startIndex, numAdded);
                assignArray(dest, propertyName, tempArray);
            } 
            else
            {
            	// For destinations like ArrayCollection we don't want to 
                // affect the array in-place in some cases, as ListCollectionView a
                // attempts to compare the "before" and "after" state of the array
                assignArray(dest, propertyName, new Array());
            }      
        }
        added = false;
    }
    
    /**
     *  @private
     */
    protected function getObjectIndex(object:Object, dest:Object):int
    {
        try
        {
            if (propertyName == null && (dest is IVisualElementContainer))
                return IVisualElementContainer(dest).getElementIndex(object as IVisualElement);
            
            if (propertyName == null && dest is IChildList)
                return IChildList(dest).getChildIndex(DisplayObject(object));
    
            if (propertyName != null && !isStyle && dest[propertyName] is IList)
                return IList(dest[propertyName].list).getItemIndex(object);
                
            if (propertyName != null && isStyle)
                return dest.getStyle(propertyName).indexOf(object);
            
            return dest[propertyName].indexOf(object);
        }
        catch(e:Error) {}
        return -1;
    }
  
    /**
     * @private 
     * Find the index of the relative object. If relativeTo is an array,
     * search for the first valid item's index.  This is used for stateful
     * documents where one or more relative siblings of the newly inserted
     * item may not be realized within the current state.
     */
    protected function getRelatedIndex(parent:UIComponent, dest:Object):int
    {
        var index:int = -1;
        if (relativeTo is Array)
        {
            for( var i:int = 0; ((i < relativeTo.length) && index < 0); i++ )
            { 
                var relativeObject:Object = getOverrideContext(relativeTo[i], parent);
                index = getObjectIndex(relativeObject, dest);
            }
        }
        else
        {
            relativeObject = getOverrideContext(relativeTo, parent);
            index = getObjectIndex(relativeObject, dest);
        }
        return index;
    }
    
    /**
     *  @private
     */
    protected function addItemsToContentHolder(dest:IVisualElementContainer, items:Array):void
    {
        if (startIndex == -1)
            startIndex = dest.numElements;
        
        for (var i:int = 0; i < items.length; i++)
            dest.addElementAt(items[i], startIndex + i);
    }
    
    /**
     *  @private
     */
    protected function addItemsToContainer(dest:IChildList, items:Array):void
    {
        if (startIndex == -1)
            startIndex = dest.numChildren;
        
        for (var i:int = 0; i < items.length; i++)
            dest.addChildAt(items[i], startIndex + i);
    }
    
    /**
     *  @private
     */
    protected function addItemsToArray(dest:Object, propertyName:String, items:Array):void
    {
        var tempArray:Array = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
        
        if (startIndex == -1)
            startIndex = tempArray.length;
        
        for (var i:int  = 0; i < items.length; i++) 
            tempArray.splice(startIndex + i, 0, items[i]);
        
        assignArray(dest, propertyName, tempArray);
    }
    
    /**
     *  @private
     */
    protected function addItemsToIList(list:IList, items:Array):void
    {       
        if (startIndex == -1)
            startIndex = list.length;
        
        for (var i:int = 0; i < items.length; i++)
            list.addItemAt(items[i], startIndex + i);   
    }
    
    /**
     *  @private
     */
    protected function removeItemsFromIList(list:IList):void
    {
        for (var i:int = 0; i < numAdded; i++)
            list.removeItemAt(startIndex);
        
    }
    
    /**
     *  @private
     */
    protected function assignArray(dest:Object, propertyName:String, value:Array):void
    {
        if (isStyle)
        {
            dest.setStyle(propertyName, value);
            dest.styleChanged(propertyName);
            dest.notifyStyleChangeInChildren(propertyName, true);
        }
        else
        {
            dest[propertyName] = value;
        }
    }
}

}
