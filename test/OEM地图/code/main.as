import com.snsoft.util.*;

stage.align = StageAlign.TOP_LEFT;

stage.scaleMode = StageScaleMode.NO_SCALE;

//信息标签数组
var clAry:Array = new Array();

//地图上名称坐标修正值 Point数组
var pntAry:Array = new Array();

//分块点击事件URL地址：包括三个属性：url ,target,request type  reqtype 
//url:http://www.baidu.com 
//target:_self or _blank or framename
var reqAry:Array = new Array();

//光影三角形颜色
var LIGHT_FILL_COLOR:uint = 0xffffff;

var LIGHT_FILL_ALPHA:Number = 0.3;

//光影线框颜色
var LIGHT_LINE_COLOR:uint = 0x000000;

var LIGHT_LINE_ALPHA:Number = 0.2;

var LIGHT_LINE_BOADER:int = 1;

var siteCard:MovieClip = this.siteCardMC;

siteCard.visible = false;

var xlp:XMLLoadParse = null;//解析XML文件

xlp = new XMLLoadParse("zh.xml");

xlp.addEventListener(Event.COMPLETE,completHandler);

xlp.parse();

//加载XML事件，从xlp中取出值
function completHandler(me:Event):void {
	
	//trace("completHandler");
	
	if (xlp != null) {
		
		var rs:RecordSet = xlp.getRecordSet();
		
		if (rs != null) {
			
			//trace("rs.length" + rs.size());
			
			for (var i:int=0; i<rs.size(); i++) {
				
				
				
				var rd:Record = rs.getBy(i);
				
				//trace("name:"+rd.getNameById(j)+" value:" + rd.getValueById(j));
				
				
				//当为一个图片时，可以不显示边框和控制栏
				
				var nm:String = rd.getValue("name");
				
				var msg:String = rd.getValue("msg");
				
				var id:String = rd.getValue("id");
				
				var index:String = "p" + id;
				
				var pnt:Point = new Point();
				
				var spntx:String = rd.getValue("x");
				
				trace(spntx);
				
				if (spntx != null) {
					
					pnt.x = Number(spntx);
					trace(pnt.x);
					
				}
				var spnty:String = rd.getValue("y");
				
				trace(spnty);
				
				if (spnty != null) {
					
					pnt.y = Number(spnty);
					
					trace(pnt.y);
					
				}
				
				var url:String = rd.getValue("url");
				
				var target:String = rd.getValue("target");
				
				var reqType:String = rd.getValue("reqtype");
				
				reqAry[index + "url"] = url;
				
				reqAry[index + "target"] = target;
				
				reqAry[index + "reqtype"] = reqType;
				
				pntAry[index] = pnt;
				
				//全部县区域透明按钮所在的MC
				var btns:MovieClip = this.map.mapBtns as MovieClip;
				
				//县区域透明按钮
				var btn:MovieClip = this.map.mapBtns[index] as MovieClip;
				
				btn.mouseEnabled = true;
				
				btn.buttonMode = true;
				
				//地图上显示县区名称
				var cns:MovieClip = getCuntryNames();
				
				var cn:CuntryName = getCuntryName(btn,nm,pnt);
				
				cn.name = index;
				
				cns.addChild(cn);
				
				
				
				//鼠标称动到某个县区上弹出的显示框
				
				var cl:CuntyLable = new CuntyLable();
				
				cl.lableName.text = nm;
				
				cl.lableText.text = msg;
				
				clAry[index] = cl;
				
				btn.doubleClickEnabled = true;
				
				btn.addEventListener(MouseEvent.MOUSE_OVER,visiableCuntryLable);
				
				btn.addEventListener(MouseEvent.MOUSE_OUT,hiddenCuntryLable);
				
				btn.addEventListener(MouseEvent.DOUBLE_CLICK,handlerOpenUrl);
				
				
				//只给弹出框赋值，先不要给弹出MC置坐标
				
			}
		}
	}
}

function handlerOpenUrl(me:MouseEvent):void {
	
	var e:MouseEvent = me as MouseEvent;
	
	var btn:MovieClip = e.currentTarget as MovieClip;
	
	var nm:String = btn.name;
	
	var url:String = reqAry[nm + "url"];
	
	var siteCard:MovieClip = this.siteCardMC;
	
	siteCard.visible = true;
}


function openurl(url:String,target:String,reqType:String):void {
	
	if (url != null) {
		
		if (target == null) {
			
			target = "_blank";
			
		}
		if (reqType == null) {
			
			reqType = "GET";
			
		}
		
		var requests:URLRequest = new URLRequest(url);
		
		requests.method = reqType;
		
		navigateToURL(requests,target);
	}
}


function visiableCuntryLable(me:MouseEvent):void {
	
	var e:MouseEvent = me as MouseEvent;
	
	var btn:MovieClip = e.currentTarget as MovieClip;
	
	var redPart:MovieClip = getRedPart(btn.name) as MovieClip;
	
	//redPart.alpha = 0.39;
	
	var btns:MovieClip = this.map.mapBtns as MovieClip;
	
	var nm:String = btn.name;
	
	var cl:CuntyLable = null;
	
	if (clAry[nm] != null && clAry[nm] is CuntyLable) {
		
		cl = clAry[nm] as CuntyLable;
		
		var p:Point = getCuntryLablePoint(cl,btn,btns);
		
		cl.x = p.x;
		
		cl.y = p.y;
		
		var pnt:Point = pntAry[nm] as Point;
		
		var cls:MovieClip = this.map.cuntryLables as MovieClip;
		
		var sp:MovieClip = createLightFace(cl,btn,btns,pnt);
		
		var lf:MovieClip = getlightFace();
		
		delAllChild(lf);
		
		lf.addChild(sp);
		
		//删除所有可能还在显示着的信息标签
		delAllChild(cls);
		
		cls.addChild(cl);
		
		var cns:MovieClip = getCuntryNames();
		
		var cn:CuntryName = cns.getChildByName(btn.name) as CuntryName;
		
		var tfd:TextField = getTextFildOfCuntryName(cn);
		
		var tft:TextFormat = new TextFormat("宋体",14,0x990000);
		
		tfd.setTextFormat(tft);
		
	}
	
}



function hiddenCuntryLable(me:MouseEvent):void {
	
	var e:MouseEvent = me as MouseEvent;
	
	var btn:MovieClip = e.currentTarget as MovieClip;
	
	var redPart:MovieClip = getRedPart(btn.name) as MovieClip;
	
	//redPart.alpha = 0;
	
	var cls:MovieClip = this.map.cuntryLables as MovieClip;
	
	//删除所有可能还在显示着的信息标签
	delAllChild(cls);
	
	var lf:MovieClip = getlightFace();
	
	delAllChild(lf);
	
	var cns:MovieClip = getCuntryNames();
	
	var cn:CuntryName = cns.getChildByName(btn.name) as CuntryName;
	
	var tfd:TextField = getTextFildOfCuntryName(cn);
	
	var tft:TextFormat = new TextFormat("宋体",14,0x000000);
	
	tfd.setTextFormat(tft);
	
}

//删除mc所有子MC
function delAllChild(mc:MovieClip) {
	
	if (mc != null) {
		
		while (mc.numChildren > 0) {
			
			mc.removeChildAt(0);
			
		}
	}
}

//通过县区的按钮位置及大小计算出县名称显示位置
function getCuntryName(btn:MovieClip,str:String,pnt:Point):CuntryName {
	
	var cn:CuntryName = new CuntryName();
	
	cn.lableName.text = str;
	
	var x:Number = btn.x + btn.width / 2;
	
	var y:Number = btn.y + btn.height / 2;
	
	cn.x = x;
	
	cn.y = y;
	
	cn.x += pnt.x;
	
	cn.y+=pnt.y;
	
	return cn;
	
}

function getTextFildOfCuntryName(cn:CuntryName):TextField {
	
	var tfd:TextField=cn.lableName;
	
	return tfd;
	
}

//通过县区的按钮位置及大小计算出县信息标签显示位置
function getCuntryLablePoint(cl:CuntyLable,btn:MovieClip,btns:MovieClip):Point {
	
	var xb:Number=btn.x+btn.width/2;
	
	var yb:Number=btn.y+btn.height/2;
	
	var xbs:Number=btns.width/2;
	
	var ybs:Number=btns.height/2;
	
	var p:Point = new Point();
	
	if (xb>xbs) {
		
		p.x=xb-btn.width/2-cl.width/2;
		
	}
	else {
		
		p.x=xb+btn.width/2+cl.width/2;
		
	}
	
	if (yb>ybs) {
		
		p.y=yb-btn.height/2-cl.height/2;
		
	}
	else {
		p.y=yb+btn.height/2+cl.height/2;
	}
	
	
	return p;
	
	
}

//县区块显示为红色的块 index 为 红块的name mapBtns 和 redParts 相同mc
//mapBtns 做按钮事件，redParts 做区块变色用。
function getRedPart(index:String):MovieClip {
	
	var redPart:MovieClip=this.map.redParts[index] as MovieClip;
	
	return redPart;
}

//光影MC要添加到 lightFace
function getlightFace():MovieClip {
	
	var lf:MovieClip=this.map.lightFace as MovieClip;
	
	return lf;
}

//所有县名称MC的父MC
function getCuntryNames():MovieClip {
	
	var cns:MovieClip=this.map.cuntryNames as MovieClip;
	
	return cns;
}

//画两个光影三角形 cl是信息标签 btn是当前县区块透明按钮，btns是全部按钮所在MC
function createLightFace(cl:MovieClip,btn:MovieClip,btns:MovieClip,pnt:Point):MovieClip {
	
	var xb:Number=btn.x+btn.width/2+pnt.x;
	
	var yb:Number=btn.y+btn.height/2+pnt.y;
	
	var xbs:Number=btns.width/2;
	
	var ybs:Number=btns.height/2;
	
	var bp:Point=new Point(xb,yb);
	
	var cp1:Point = new Point();
	
	var cp2:Point = new Point();
	
	var cp3:Point = new Point();
	
	if (xb>xbs&&yb>ybs) {
		
		cp1.x=cl.x-cl.width/2;
		
		cp1.y=cl.y+cl.height/2;
		
		cp2.x=cl.x+cl.width/2;
		
		cp2.y=cl.y+cl.height/2;
		
		cp3.x=cl.x+cl.width/2;
		
		cp3.y=cl.y-cl.height/2;
		
	}
	else if (xb > xbs && yb < ybs) {
		
		cp1.x=cl.x+cl.width/2;
		
		cp1.y=cl.y+cl.height/2;
		
		cp2.x=cl.x+cl.width/2;
		
		cp2.y=cl.y-cl.height/2;
		
		cp3.x=cl.x-cl.width/2;
		
		cp3.y=cl.y-cl.height/2;
		
	}
	else if (xb < xbs && yb > ybs) {
		
		cp1.x=cl.x-cl.width/2;
		
		cp1.y=cl.y-cl.height/2;
		
		cp2.x=cl.x-cl.width/2;
		
		cp2.y=cl.y+cl.height/2;
		
		cp3.x=cl.x+cl.width/2;
		
		cp3.y=cl.y+cl.height/2;
		
	}
	else if (xb < xbs && yb < ybs) {
		
		cp1.x=cl.x+cl.width/2;
		
		cp1.y=cl.y-cl.height/2;
		
		cp2.x=cl.x-cl.width/2;
		
		cp2.y=cl.y-cl.height/2;
		
		cp3.x=cl.x-cl.width/2;
		
		cp3.y=cl.y+cl.height/2;
		
	}
	
	
	var sps:MovieClip = new MovieClip();
	
	sps.addChild(drawLightFill(bp,cp1,cp2));
	
	sps.addChild(drawLightFill(bp,cp2,cp3));
	
	sps.addChild(drawLightLine(bp,cp2));
	
	return sps;
	
	
}

//画线
function drawLightLine(p1:Point,p2:Point) {
	
	var sp:Shape = new Shape();
	
	var gra:Graphics=sp.graphics;
	
	gra.lineStyle(LIGHT_LINE_BOADER,LIGHT_LINE_COLOR,LIGHT_LINE_ALPHA);
	
	gra.moveTo(p1.x,p1.y);
	
	gra.lineTo(p2.x,p2.y);
	
	return sp;
	
}


//画三角形
function drawLightFill(bp:Point,cp1:Point,cp2:Point):Shape {
	
	var sp:Shape = new Shape();
	
	var gra:Graphics=sp.graphics;
	
	gra.beginFill(LIGHT_FILL_COLOR,LIGHT_FILL_ALPHA);
	
	gra.moveTo(bp.x,bp.y);
	
	gra.lineTo(cp1.x,cp1.y);
	
	gra.lineTo(cp2.x,cp2.y);
	
	gra.lineTo(bp.x,bp.y);
	
	gra.endFill();
	
	return sp;
	
}