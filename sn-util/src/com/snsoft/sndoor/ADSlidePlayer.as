package com.snsoft.sndoor{
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 幻灯片 
	 * @author Administrator
	 * 
	 */	
	public class ADSlidePlayer extends UIComponent{
		
		/**
		 * 
		 */		
		private var back:MovieClip;	
		
		
		private var btnBack:MovieClip;
		
		/**
		 * 
		 */		
		private var slideDOV:Vector.<SlideDO>;
		
		/**
		 * 
		 */		
		private var newSlideLayer:MovieClip;
		
		/**
		 * 
		 */		
		private var oldSlideLayer:MovieClip;
		
		
		/**
		 * 
		 */		
		private var oldSlideDobj:MovieClip;
		
		/**
		 * 
		 */		
		private var newSlideDobj:MovieClip;
		
		
		private var slideIndex:int = 0;
		
		private var currentBtnIndex:int = 0;
		
		private var isMouseOverCurrenBtn:Boolean = false;
		
		private var slideTimer:Timer;
		
		private var effectTimer:Timer
		
		private var mediaBox:MediaBox;
		
		private var imageBox:ImageBox;
		
		private var btnsLayer:MovieClip;
		
		private var btnsV:Vector.<ADSlideBtn> = new Vector.<ADSlideBtn>();
		
		private static const BTN_BACK_HEIGHT:Number = 64;
		
		private static const BTN_WIDTH:Number = 120;
		
		private static const BTN_HEIGHT:Number = 50;
		
		/**
		 * 
		 * @param slideDO
		 * @param width
		 * @param height
		 * 
		 */		
		public function ADSlidePlayer(slideDOV:Vector.<SlideDO>,imageBox:ImageBox,mediaBox:MediaBox,width:Number,height:Number)
		{
			super();
			
			this.width = width;
			this.height = height;
			this.slideDOV = slideDOV;
			this.mediaBox = mediaBox;
			this.imageBox = imageBox;
			
			slideTimer = new Timer(3000,1);
			slideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerTimerCmp);
			
			oldSlideLayer = new MovieClip();
			newSlideLayer = new MovieClip();
			
			back = getDisplayObjectInstance(getStyleValue(slideAssistSkin)) as MovieClip;
			back.width = width;
			back.height = height;
			
			btnBack = getDisplayObjectInstance(getStyleValue(slideBtnBackSkin)) as MovieClip;
			btnBack.width = width;
			btnBack.height = BTN_BACK_HEIGHT;
			btnBack.y = height - btnBack.height;
			
			btnsLayer = new MovieClip();
			btnsLayer.y = height - btnBack.height;
		}
		
		/**
		 * 样式 
		 */			
		private static var defaultStyles:Object = {
			slideBtnAlphaSkin:"SlideBtnAlpha_skin",
			slideAssistSkin:"SlideAssist_skin",
			slideBtnBackSkin:"SlideBtnBack_skin"
		};
		
		/**
		 * 样式  
		 */		
		private static const slideAssistSkin:String = "slideAssistSkin";
		
		private static const slideBtnBackSkin:String = "slideBtnBackSkin";
		
		private static const slideBtnAlphaSkin:String = "slideBtnAlphaSkin";
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}	
		/**
		 *  
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			this.addChild(back);
			this.addChild(oldSlideLayer);
			this.addChild(newSlideLayer);
			this.addChild(btnBack);
			this.addChild(btnsLayer);
			
			var btnsBorder:Number = 50;
			var btnMinSep:Number = 20;
			var btnSep:Number = 0;
			
			var btnWidth:Number = this.width - btnsBorder - btnsBorder - (slideDOV.length - 1) * btnMinSep;
			
			if(btnWidth > BTN_WIDTH){
				btnWidth = BTN_WIDTH;
			}
			
			btnSep = (this.width - btnsBorder - btnsBorder - btnWidth * slideDOV.length)/ (slideDOV.length - 1);
			
			var btnx:Number = btnsBorder;
			for(var i:int = 0;i < slideDOV.length;i ++){
				
				var sdo:SlideDO = slideDOV[i];
				var bmd:BitmapData = imageBox.getImageByUrl(sdo.image);
				
				var adsBtn:ADSlideBtn = new ADSlideBtn(bmd,i,btnWidth,BTN_HEIGHT);
				adsBtn.drawNow();
				adsBtn.x = btnx;
				adsBtn.y = (BTN_BACK_HEIGHT - BTN_HEIGHT) / 2; 
				
				adsBtn.addEventListener(MouseEvent.MOUSE_OVER,handlerADSlideBtnMouseOver);
				adsBtn.addEventListener(MouseEvent.MOUSE_OUT,handlerADSlideBtnMouseOut);
				
				btnsLayer.addChild(adsBtn);
				btnsV.push(adsBtn);
				
				btnx += btnSep + btnWidth;
			}
			
			newSlideDobj = getSlideByLoop();
			newSlideLayer.addChild(newSlideDobj);
			setBtnIsSlideVisible(0);
			startTimer();
		}
		
		
		private function handlerADSlideBtnMouseOver(e:Event):void{
			var adsBtn:ADSlideBtn = e.currentTarget as ADSlideBtn;
			var cindex:int = this.getPreviousSlideIndex();
			stopTimer();
			isMouseOverCurrenBtn = true;
			if(adsBtn.index != cindex){
				setSlideIndex(adsBtn.index);
				changeToNextSlide();
			}
		}
		
		private function handlerADSlideBtnMouseOut(e:Event):void{
			if(isMouseOverCurrenBtn){
				isMouseOverCurrenBtn = false;
				startTimer();
			}
		}
		
		private function startTimer():void{
			if(slideDOV.length > 1 && !isMouseOverCurrenBtn){
				if(slideTimer != null){
					slideTimer.start();
				}
			}
		}
		
		private function stopTimer():void{
			if(slideTimer != null){
				slideTimer.stop(); 
			}
			if(effectTimer != null){
				effectTimer.stop();
			}
		}
		
		private function handlerTimerCmp(e:Event):void{
			changeToNextSlide();
		}
		
		private function changeToNextSlide():void{
			oldSlideDobj = newSlideDobj;
			oldSlideLayer.addChild(oldSlideDobj);
			newSlideDobj = getSlideByLoop();
			newSlideDobj.alpha = 0;
			newSlideLayer.addChild(newSlideDobj);
			var cindex:int = getPreviousSlideIndex();
			setBtnIsSlideVisible(cindex);
			
			effectTimer = new Timer(30,20);
			effectTimer.addEventListener(TimerEvent.TIMER,handlerEffectTimer);
			effectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handlerEffectTimerCmp);
			effectTimer.start();
		}
		
		
		private function handlerEffectTimer(e:Event):void{
			newSlideDobj.alpha += 0.05;
		}
		
		private function handlerEffectTimerCmp(e:Event):void{
			newSlideDobj.alpha = 1;
			effectTimer.removeEventListener(TimerEvent.TIMER,handlerEffectTimer);
			effectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,handlerEffectTimerCmp);
			SpriteUtil.deleteAllChild(oldSlideLayer);
			startTimer();
		}
		
		private function setBtnIsSlideVisible(index:int):void{
			for(var i:int = 0;i < btnsV.length;i ++){
				var adsBtn:ADSlideBtn = btnsV[i];
				trace("setBtnSlideVisible",i,index);
				if(i == index){
					adsBtn.setBtnSlideVisible(true);
				}
				else {
					adsBtn.setBtnSlideVisible(false);
				}
			}
		}
		
		private function getPreviousSlideIndex():int{
			var index:int = slideIndex -1;
			if(index < 0){
				index = slideDOV.length - 1;
			}
			return index;
		}
		
		private function getSlideIndex():int{
			return slideIndex;
		}
		
		private function setSlideIndex(index:int):void{
			slideIndex = index;
		}
		
		private function getSlideByLoop():MovieClip{
			var slide:MovieClip = new MovieClip();
			
			var slideDO:SlideDO = slideDOV[slideIndex];
			var dobj:DisplayObject= mediaBox.getMediaByUrl(slideDO.media);
			if(dobj is Bitmap){
				var bm:Bitmap = dobj as Bitmap;
				slide.addChild(bm);
			}
			else if(dobj is MovieClip){
				var mc:MovieClip = dobj as MovieClip;
				slide.addChild(mc);
				mc.play();
			}
			slideIndex ++ ;
			if(slideIndex > slideDOV.length - 1){
				slideIndex = 0;
			}
			return slide;
		}
	}
}