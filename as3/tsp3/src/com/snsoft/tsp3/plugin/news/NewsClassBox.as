﻿package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.hand.HandGroup;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsClassBox extends MySprite {

		public static const ALIGN_LEFT:String = "left";

		public static const ALIGN_RIGHT:String = "right";

		public static const EVENT_BACK:String = "eventBack";

		public static const EVENT_BTN_CLICK:String = "eventBtnClick";

		private var btnsv:Vector.<Sprite> = new Vector.<Sprite>();

		private var backLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var btnLayer:Sprite = new Sprite();

		private var backBtnLayer:Sprite = new Sprite();

		private var handLayer:Sprite = new Sprite();

		private var boxWidth:int;

		private var boxHeight:int;

		private var boader:int = 5;

		private var boader2:int = 10;

		private var _classType:String;

		private var align:String;

		private var _data:DataDTO;

		private var clickLock:Boolean = false;

		private var hiddenBack:Boolean = false;

		private var currentBtns:Sprite;

		private var btnH:int;

		private var btnsY:int;

		private var maskW:int;

		private var _title:String;

		private var twn:Tween;

		private var twn2:Tween;

		private var currentClickBtn:NewsClassBtn;

		private var cbtnv:Vector.<NewsClassBtn>;

		private var _unSelectedSkin:String = "NewsClassBtn_unSelectedSkin";

		private var _selectedSkin:String = "NewsClassBtn_selectedSkin";

		private var _backBtnSkin:String = "NewsClassBox_backBtnSkin";

		private var _backSkin:String = "NewsClassBox_backSkin";

		private var _selTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);

		private var _unSelTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);

		private var handg:HandGroup;

		private var td:TouchDrag;

		public function NewsClassBox(boxWidth:int, boxHeight:int, title:String, classType:String = null, hiddenBack:Boolean = false, align:String = "left") {
			this.boxWidth = boxWidth;
			this.boxHeight = boxHeight;
			this.title = title;
			this.hiddenBack = hiddenBack;
			this.classType = classType;
			this.align = align;
			super();
		}

		override protected function configMS():void {

		}

		override protected function draw():void {

			this.addChild(backLayer);
			this.addChild(backBtnLayer);
			this.addChild(maskLayer);
			this.addChild(btnLayer);
			this.addChild(handLayer);

			handLayer.mouseChildren = false;
			handLayer.mouseEnabled = false;

			var back:Sprite = SkinsUtil.createSkinByName(backSkin);
			backLayer.addChild(back);
			back.width = boxWidth;
			back.height = boxHeight;

			var tfdw:int = 0;

			if (title != null) {
				var tfd:TextField = new TextField();
				tfd.defaultTextFormat = unSelTft;
				tfd.autoSize = TextFieldAutoSize.LEFT;
				tfd.embedFonts = true;
				tfd.antiAliasType = AntiAliasType.ADVANCED;
				tfd.gridFitType = GridFitType.PIXEL;
				tfd.thickness = 100;
				tfd.text = title + "：";
				tfd.mouseEnabled = false;
				backLayer.addChild(tfd);
				tfd.x = boader;
				tfd.y = (boxHeight - tfd.height) / 2;
				tfdw = tfd.width;
			}
			var bw:int = 0;
			if (!hiddenBack) {
				var backBtn:MovieClip = SkinsUtil.createSkinByName(backBtnSkin);
				backBtn.buttonMode = true;
				backBtnLayer.addChild(backBtn);
				backBtn.x = int(boxWidth - boader - backBtn.width);
				backBtn.y = int(boxHeight - backBtn.height) / 2;
				backBtn.addEventListener(MouseEvent.CLICK, handlerBackBtnMouseClick);
				bw = backBtn.width + boader;
			}
			var btn:NewsClassBtn = new NewsClassBtn("aaaa");
			btn.unSelectedSkin = unSelectedSkin;
			btn.selectedSkin = selectedSkin;
			btn.selTft = selTft;
			btn.unSelTft = unSelTft;
			btn.drawNow();
			btnH = btn.height;
			btnsY = int((boxHeight - btnH) / 2);

			var btnsX:int = boader2 + tfdw;

			maskW = boxWidth - btnsX - bw - boader2;

			var mask:Sprite = ViewUtil.creatRect(maskW, btnH);
			mask.x = btnsX;
			mask.y = btnsY;
			maskLayer.addChild(mask);

			btnLayer.mask = mask;
			btnLayer.x = btnsX;

			handg = new HandGroup(btnH, btnH);
			handg.right.visible = false;
			handLayer.addChild(handg.right);
			handg.right.x = boader2 + btnsX;
			handg.right.y = boxHeight - btnH;

			handg.left.visible = false;
			handLayer.addChild(handg.left);
			handg.left.x = maskW - handg.left.width + boader2 + btnsX;
			handg.left.y = boxHeight - btnH;
		}

		public function clear():void {
			btnsv = new Vector.<Sprite>();
			SpriteUtil.deleteAllChild(btnLayer);
		}

		public function addChildren(v:Vector.<DataDTO>):void {
			if (v != null && v.length > 0) {
				var btns:Sprite = new Sprite();
				btnLayer.addChild(btns);
				var back:Sprite = ViewUtil.creatRect(100, boxHeight);
				btns.addChild(back);

				var w:int = 0;
				cbtnv = new Vector.<NewsClassBtn>();
				for (var i:int = 0; i < v.length; i++) {
					var dto:DataDTO = v[i];
					var ntbtn:NewsClassBtn = new NewsClassBtn(dto.text);
					ntbtn.unSelectedSkin = unSelectedSkin;
					ntbtn.selectedSkin = selectedSkin;
					ntbtn.selTft = selTft;
					ntbtn.unSelTft = unSelTft;
					ntbtn.data = dto;
					ntbtn.buttonMode = true;
					btns.addChild(ntbtn);
					cbtnv.push(ntbtn);
					ntbtn.x = w;
					w += ntbtn.width;
					back.height = ntbtn.height;
				}
				back.width = w;
				btns.y = w;

				btnsv.push(btns);
				btnLayer.y = btnsY;

				var px:int =  maskLayer.width - w;
				var rx:int = 0;
				var rw:int = 0;
				if (px > 0 && align == ALIGN_RIGHT) {
					btns.x = px;
					rx = px;
				}
				else {
					rx = Math.min(px, 0);
					rw = -rx;
				}

				var rect:Rectangle = new Rectangle(rx, 0, rw, 0);
				td = new TouchDrag(btns, stage, rect, 5);
				for (var j:int = 0; j < cbtnv.length; j++) {
					var btn:NewsClassBtn = cbtnv[j];
					td.addClickObj(btn);
				}
				td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerTouchClick);
				td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerDragOver);
				setHandsState();
				var oldBtns:Sprite = currentBtns;
				currentBtns = btns;
				tweenMove(currentBtns, oldBtns, -1);
			}
		}

		private function handlerDragOver(e:Event):void {
			setHandsState();
		}

		private function setHandsState():void {
			trace("handlerDragOver", td.isStart, td.isEnd);
			handg.right.visible = !td.isStart;
			handg.left.visible = !td.isEnd;
		}

		private function tweenMove(cbtn:Sprite, obtn:Sprite, sign:int):void {
			clickLock = true;
			var start:int = 0;
			var end:int = 0;

			if (sign == 1) {
				start = 0;
				end = boxHeight;
			}
			else if (sign == -1) {
				start = boxHeight;
				end = 0;
			}

			if (obtn != null) {
				twn2 = new Tween(obtn, "y", Regular.easeOut, start - boxHeight, end - boxHeight, 0.3, true);
				twn2.start();
			}

			twn = new Tween(cbtn, "y", Regular.easeOut, start, end, 0.3, true);
			if (sign == -1) {
				twn.addEventListener(TweenEvent.MOTION_FINISH, handlerTweenInCmp);
			}
			else if (sign == 1) {
				twn.addEventListener(TweenEvent.MOTION_FINISH, handlerTweenBackCmp);
			}
			twn.start();

		}

		private function handlerTweenInCmp(e:Event):void {
			twn.removeEventListener(TweenEvent.MOTION_FINISH, handlerTweenInCmp);
			twn.removeEventListener(TweenEvent.MOTION_FINISH, handlerTweenBackCmp);
			twn.stop();
			if (twn2 != null) {
				twn2.stop();
			}
			clickLock = false;
		}

		private function handlerTweenBackCmp(e:Event):void {
			twn.removeEventListener(TweenEvent.MOTION_FINISH, handlerTweenInCmp);
			twn.removeEventListener(TweenEvent.MOTION_FINISH, handlerTweenBackCmp);
			var btns:Sprite = btnsv.pop();
			btnLayer.removeChildAt(btnLayer.numChildren - 1);
			currentBtns = btnsv[btnsv.length - 1];
			clickLock = false;
		}

		private function handlerTouchClick(e:Event):void {
			//trace("handlerTouchClick");
			if (!clickLock) {
				var tg:TouchDrag = e.currentTarget as TouchDrag;
				var btn:NewsClassBtn = tg.clickObj as NewsClassBtn;
				var dto:DataDTO = btn.data;
				_data = dto;
				setSelectBtn(btn);
				this.dispatchEvent(new Event(EVENT_BTN_CLICK));
			}
		}

		private function setSelectBtn(btn:NewsClassBtn):void {
			if (this.currentClickBtn != null) {
				this.currentClickBtn.setSectcted(false);
			}
			btn.setSectcted(true);
			currentClickBtn = btn;
		}

		public function selectedDef(i:int):void {
			if (cbtnv != null) {
				if (i >= 0 && i < cbtnv.length) {
					setSelectBtn(cbtnv[i]);
				}
			}
		}

		private function handlerBackBtnMouseClick(e:Event):void {
			if (!clickLock) {
				if (btnsv.length >= 2) {
					var n:int = btnsv.length - 1;
					var cbtn:Sprite = btnsv[n];
					var obtn:Sprite = btnsv[n - 1];
					tweenMove(cbtn, obtn, 1);
					this.dispatchEvent(new Event(EVENT_BACK));
				}
			}
		}

		public function get classType():String {
			return _classType;
		}

		public function get unSelectedSkin():String {
			return _unSelectedSkin;
		}

		public function set unSelectedSkin(value:String):void {
			_unSelectedSkin = value;
		}

		public function get selectedSkin():String {
			return _selectedSkin;
		}

		public function set selectedSkin(value:String):void {
			_selectedSkin = value;
		}

		public function get backBtnSkin():String {
			return _backBtnSkin;
		}

		public function set backBtnSkin(value:String):void {
			_backBtnSkin = value;
		}

		public function get backSkin():String {
			return _backSkin;
		}

		public function set backSkin(value:String):void {
			_backSkin = value;
		}

		public function get selTft():TextFormat {
			return _selTft;
		}

		public function set selTft(value:TextFormat):void {
			_selTft = value;
		}

		public function get unSelTft():TextFormat {
			return _unSelTft;
		}

		public function set unSelTft(value:TextFormat):void {
			_unSelTft = value;
		}

		public function set classType(value:String):void {
			_classType = value;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function get data():DataDTO {
			return _data;
		}

	}
}
