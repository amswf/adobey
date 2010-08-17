// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.controls {

	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import fl.controls.TextInput; //Only for ASDocs
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

    //--------------------------------------
    //  Events
    //--------------------------------------
	/**
     * Dispatched after there is a change in the width or height of the component.
 	 * <p><strong>Note:</strong> This event does not occur if you use ActionScript code to change the label text.</p>
 	 *
     * @eventType fl.events.ComponentEvent.RESIZE
     *
     * @includeExample examples/Label.resize.1.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
 	 */
	[Event(name="resize", type="fl.events.ComponentEvent")]


    //--------------------------------------
    //  Styles
    //--------------------------------------
	/**
     * @copy fl.controls.LabelButton#style:embedFonts
     *
     * @default false
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Style(name="embedFonts", type="Boolean")]
    
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * A Label component displays one or more lines of plain or 
	 * HTML-formatted text that can be formatted for alignment and
	 * size. Label components do not have borders and cannot receive 
	 * focus.
	 *
	 * <p>A live preview of each Label instance reflects the changes
	 * that were made to parameters in the Property inspector or Component
	 * inspector during authoring. Because a Label component does not have a border,
	 * the only way to see the live preview for a Label instance is to set 
	 * its <code>text</code> property. The <code>autoSize</code> property is not supported 
	 * in live preview.</p>
	 * 
     * @includeExample examples/LabelExample.as
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	public class Label extends UIComponent {
		/**
         * A reference to the internal text field of the Label component.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public var textField:TextField;		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var actualWidth:Number;		

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var actualHeight:Number;		

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var defaultLabel:String = "Label";

		/**
		 * @private (protected)
		 */
		protected var _savedHTML:String;

		/**
		 * @private (protected)
		 */
		protected var _html:Boolean = false;

		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static var defaultStyles:Object = {textFormat:null, embedFonts:false};

        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
		 * @includeExample ../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *
         * @see fl.core.UIComponent#getStyle() UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle() UIComponent#setStyle()
         * @see fl.managers.StyleManager StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static function getStyleDefinition():Object { return defaultStyles; }

		/**
         * Creates a new Label component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function Label() {
			super();
			
			text = defaultLabel;
			actualWidth = _width;
			actualHeight = _height;
		}
		
		[Inspectable(defaultValue="Label")]
		/**
         * Gets or sets the plain text to be displayed by the Label component.
         *
         * <p>Note that characters that represent HTML markup have no special 
		 * meaning in the string and will appear as they were entered.</p>
         *
         * <p>To display text that contains HTML tags, use the <code>htmlText</code>
         * property. The HTML replaces any text that you set by using the <code>htmlText</code> 
		 * property, and the <code>text</code> property returns a plain text version of 
		 * the HTML text, with the HTML tags removed.</p>
         *
         * <p>If the <code>text</code> property is changed from the default value in the
         * property inspector, it takes precedence over the <code>htmlText</code> 
         * property in the property inspector.</p>
         *
         * @default "Label"
         *
         * @see #htmlText
         * @see flash.text.TextField#text
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */ 
		public function get text():String {
			return textField.text;
		}


		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set text(value:String):void {
			// Value is the same as what is already set.
			if (value == text) { 
				return;
			}	
			
			// Value in the PI is the default.
			if (componentInspectorSetting && value == defaultLabel) {
				return;
			}
			
			// Clear the HTML value, and redraw.
			_html = false;
			textField.text = value;	
			if (textField.autoSize != TextFieldAutoSize.NONE) { 
				invalidate(InvalidationType.SIZE);
			}
		}
		
		[Inspectable(defaultValue="")]
		/**
         * Gets or sets the text to be displayed by the Label component, including 
		 * HTML markup that expresses the styles of that text. You can specify HTML
		 * text in this property by using the subset of HTML tags that are supported
         * by the TextField object.
         *
         * <p>If the default value of the <code>text</code> property is changed in the
         * Property inspector, this changed value takes precedence over any value in the 
         * <code>htmlText</code> property field in the Property inspector. To use the 
         * <code>htmlText</code> property in the Property inspector, the <code>text</code> property
         * field must contain the value <code>Label</code>, exactly as shown. When coding with 
         * ActionScript, you do not need to set the value of the <code>text</code> property; the 
         * default value is <code>Label</code>.</p>
         *
         * @default ""
         *
         * @see #text
         * @see flash.text.TextField#htmlText
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function get htmlText():String {
			return textField.htmlText;
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set htmlText(value:String):void {
			// Value is the same as what is already set.
			if (value == htmlText) { 
				return;
			}
			
			// Nothing is set in the PI.
			if (componentInspectorSetting && value == "") { 
				return;
			}
			
			// Remember the html for later.
			_html = true;
			_savedHTML = value;
			
			// Change the text, and possibly resize.
			textField.htmlText = value;
			if (textField.autoSize != TextFieldAutoSize.NONE) { 
				invalidate(InvalidationType.SIZE);
			}
		}
		
		[Inspectable(defaultValue=false)]
		/**
         * Gets or sets a value that indicates whether extra white space such as spaces 
		 * and line breaks should be removed from a Label component that contains HTML text. 
		 * A value of <code>true</code> indicates that white space is to be removed; a
		 * value of <code>false</code> indicates that it remains.
		 *
         * <p>The <code>condenseWhite</code> property affects only text that was set by 
         * using the <code>htmlText</code> property, not the <code>text</code> property. 
         * If you set text by using the <code>text</code> property, the <code>condenseWhite</code> 
		 * property is ignored.</p>
		 *
         * <p>If you set the <code>condenseWhite</code> property to <code>true</code>, 
         * you must use standard HTML commands, such as &lt;br&gt; and &lt;p&gt;, to break
		 * the lines of the text in the text field.</p>
         *
         * @default false
		 *
		 * @includeExample examples/Label.condenseWhite.1.as -noswf
         *
         * @see #htmlText
         * @see flash.text.TextField#condenseWhite
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		public function get condenseWhite():Boolean {
			return textField.condenseWhite;
		}
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set condenseWhite(value:Boolean):void {
			textField.condenseWhite = value;
			if (textField.autoSize != TextFieldAutoSize.NONE) { invalidate(InvalidationType.SIZE); }
		}
		
		[Inspectable(defaultValue=false)]
		/**
         * Gets or sets a value that indicates whether the text can be selected. A value 
		 * of <code>true</code> indicates that it can be selected; a value of <code>false</code> 
		 * indicates that it cannot. 
		 *
		 * <p>Text that can be selected can be copied from the Label component by the user.</p> 
         *
         * @default false
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	    
		public function get selectable():Boolean {
			return textField.selectable;
		}		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set selectable(value:Boolean):void {
			textField.selectable = value;
		}
		
		[Inspectable(defaultValue=false)]
		/**
		 * Gets or sets a value that indicates whether the text field supports word wrapping.
		 * A value of <code>true</code> indicates that it does; a value of <code>false</code>
		 * indicates that it does not.
         *
         * @default false
         *
         * @includeExample examples/Label.wordWrap.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		public function get wordWrap():Boolean {
			return textField.wordWrap;
		}		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set wordWrap(value:Boolean):void {
			textField.wordWrap = value;
			if (textField.autoSize != TextFieldAutoSize.NONE) { invalidate(InvalidationType.SIZE); }
		}
		
		[Inspectable(enumeration="left,center,right,none",defaultValue="none")]
		/**
	  	 * Gets or sets a string that indicates how a label is sized and aligned to
         * fit the value of its <code>text</code> property. The following are
		 * valid values:
         * <ul>
         *     <li><code>TextFieldAutoSize.NONE</code>: The label is not resized or aligned to fit the text.</li>
         *     <li><code>TextFieldAutoSize.LEFT</code>: The right and bottom sides of the label are resized to fit the text.
	     *	       The left and top sides are not resized.</li>
         *     <li><code>TextFieldAutoSize.CENTER</code>: The left and right sides of the label resize to fit the text.
	     *	       The horizontal center of the label stays anchored at its original horizontal
	     *	       center position.</li>
         *     <li><code>TextFieldAutoSize.RIGHT</code>: The left and bottom sides of the label are resized to fit
	     *	       the text. The top and right sides are not resized.</li>
         *  </ul>
         *
         * @default TextFieldAutoSize.NONE
         *
		 * @includeExample examples/Label.autoSize.1.as -noswf
		 *
         * @see flash.text.TextFieldAutoSize TextFieldAutoSize
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
	     */		
		public function get autoSize():String {
			return textField.autoSize;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set autoSize(value:String):void {
			textField.autoSize = value;
			invalidate(InvalidationType.SIZE);
		}		
		
		/**
         * @copy fl.core.UIComponent#width
         *
         * @see #height
         * @see fl.core.UIComponent#setSize()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get width():Number {
			if (textField.autoSize != TextFieldAutoSize.NONE && !wordWrap) {
				return _width;
			} else {
				return actualWidth;	
			}
		}		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set width(value:Number):void {
			actualWidth = value;
			super.width = value;
		}
		
		/**
		 * @copy fl.core.UIComponent#height
         *
         * @see #width
         * @see fl.core.UIComponent#setSize()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get height():Number {
			if (textField.autoSize != TextFieldAutoSize.NONE && wordWrap) {
				return _height;
			} else {
				return actualHeight;	
			}
		}		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function setSize(width:Number, height:Number):void {
			actualWidth = width;
			actualHeight = height;
			super.setSize(width,height);
		}
		
		
		
		/**
         * @private (protected)
		 */
		override protected function configUI():void {
			super.configUI();
			
			textField = new TextField();
			addChild(textField);
			textField.type = TextFieldType.DYNAMIC;
			textField.selectable = false;
			textField.wordWrap = false;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void {
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				drawTextFormat();
				
				var embed:Object = getStyleValue('embedFonts');
				if (embed != null) {
					textField.embedFonts = embed;
				}
				
				if (textField.autoSize != TextFieldAutoSize.NONE) { 
					invalidate(InvalidationType.SIZE,false);
				}
			}
			if (isInvalid(InvalidationType.SIZE)) {
				drawLayout();
			}
			super.draw();
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawTextFormat():void {
			var tf:TextFormat = getStyleValue("textFormat") as TextFormat;
			if (tf == null) {
				var uiStyles:Object = UIComponent.getStyleDefinition();
				tf = enabled ? uiStyles.defaultTextFormat as TextFormat : uiStyles.defaultDisabledTextFormat as TextFormat;
			}
			
			textField.defaultTextFormat = tf; // This removes HTML Styles...
			textField.setTextFormat(tf);
			
			// Set the HTML again to make sure that the html styles are preserved.
			if (_html && _savedHTML != null) { htmlText = _savedHTML; }
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawLayout():void {
			var resized:Boolean = false;
			
			textField.width = width;
			textField.height = height;
			
			if (textField.autoSize != TextFieldAutoSize.NONE) {
				
				var txtW:Number = textField.width;
				var txtH:Number = textField.height;
				
				resized = (_width != txtW || _height != txtH);
				// set the properties directly, so we don't trigger a callLater:
				_width = txtW;
				_height = txtH;
				
				switch (textField.autoSize) {
					case TextFieldAutoSize.CENTER:
						textField.x = (actualWidth/2)-(textField.width/2);
						break;
					case TextFieldAutoSize.LEFT:
						textField.x = 0;
						break;
					case TextFieldAutoSize.RIGHT:
						textField.x = -(textField.width - actualWidth);
						break;
				}
			} else {
				textField.width = actualWidth;
				textField.height = actualHeight;
				textField.x = 0;	
			}
			
			if (resized) { 
				dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, true));
			}
		}
		
	}
}