package com.snsoft.peopleRes8{
	import com.snsoft.util.SpriteUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class PeopleMove extends Sprite{
		
		/**
		 * 键盘键码  左
		 */		
		private static const LEFT:int = 37;
		
		/**
		 * 键盘键码  上
		 */	
		private static const FRONT:int = 38;
		
		/**
		 * 键盘键码  右
		 */	
		private static const RIGHT:int = 39;
		
		/**
		 * 键盘键码  下
		 */	
		private static const BACK:int = 40;
		
		/**
		 * 组合键队列 
		 */		
		private var keyCodeV:Vector.<int> = new Vector.<int>();
		
		/**
		 * 八方走图片加载器 
		 */		
		private var peopleRes:PeopleRes;
		
		/**
		 * 人物动作第N个图片 
		 */		
		private var imageIndex:int = 0;
		
		/**
		 * 人物图片所放的层 
		 */		
		private var imageLayer:Sprite;
		
		public function PeopleMove(peopleRes:PeopleRes)
		{
			this.peopleRes = peopleRes;
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddToStage);
		}
		
		/**
		 * 把当前键放入队列中，并且把超出的删除
		 * @param keyCode
		 * 
		 */		
		private function pushKeyCode(keyCode:int):void{
			keyCodeV.push(keyCode);
			if(keyCodeV.length >2){
				keyCodeV.splice(0,keyCodeV.length - 2);
			}
		}
		
		/**
		 * 初始化
		 * @param e
		 * 
		 */		
		private function handlerAddToStage(e:Event):void{
			imageLayer = new Sprite();
			this.addChild(imageLayer);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,handlerKeyDown);	
			stage.addEventListener(KeyboardEvent.KEY_UP,handlerKeyUp);
			keyCodeV.push(-1,-1);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		/**
		 * 人物运动 
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			
			var code:int = getGroupKeyCode();
			var bmd:BitmapData;
			if(code >= 0){
				var direction:int = Direction8.tranDirection(code);
				var index:int = getNextIndex();
				bmd = peopleRes.getImage(direction,index);
			}
			else{
				bmd = peopleRes.getImage(0,0);
			}
			SpriteUtil.deleteAllChild(imageLayer);
			var bm:Bitmap = new Bitmap(bmd,"auto",true);
			imageLayer.addChild(bm);
		}
		
		/**
		 * 从组合键队列读取键值
		 * 计算出的结果为，从左顺时针转一圈为0 ~ 7的编号 
		 * @return 
		 * 
		 */		
		private function getGroupKeyCode():int{
			var key1:int = tranKeyCode(keyCodeV[0]);
			var key2:int = tranKeyCode(keyCodeV[1]);
			
			var code:int = -1;
			
			if(key1 >= 0 || key2 >= 0){
				code = 0;
			}
			if(key1 >= 0){
				code += key1;
			}
			if(key2 >= 0){
				code += key2;
			}
			if((key1 == 0 && key2 == 6) || (key1 == 6 && key2 == 0)){
				code += 8;
			}
			if(key1 >= 0 && key2 >= 0){
				code = code / 2;
			}
			return code;
		}
		
		/**
		 * 获得下一个动作图片的编号 
		 * @return 
		 * 
		 */		
		private function getNextIndex():int{
			imageIndex ++;
			if(imageIndex >= 8){
				imageIndex = 0;
			}
			return imageIndex;
		}
		
		/**
		 * 键码转换   左0 	上2	右4	下6 ,组合键为 相邻两个值的和除以2,0 和 6 特殊处理，要加8。
		 * 计算出的结果为，从左顺时针转一圈为0 ~ 7的编号
		 * @param keyCode
		 * @return 
		 * 
		 */		
		private function tranKeyCode(keyCode:int):int{
			if(keyCode == LEFT){
				return 0;
			}
			else if(keyCode == FRONT){
				return 2;
			}
			else if(keyCode == RIGHT){
				return 4;
			}
			else if(keyCode == BACK){
				return 6;
			}
			return -1;
		}
		
		/**
		 * 键按下事件
		 * @param e
		 * 
		 */		
		private function handlerKeyDown(e:KeyboardEvent):void{
			if(e.keyCode != keyCodeV[0] && e.keyCode != keyCodeV[1]){
				pushKeyCode(e.keyCode);
			}
		}
		
		/**
		 * 键弹起事件
		 * @param e
		 * 
		 */		
		private function handlerKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == keyCodeV[0]){
				keyCodeV[0] = -1;
			}
			else if(e.keyCode == keyCodeV[1]){
				keyCodeV[1] = -1;
			}
		}
	}
}