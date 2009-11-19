class ETF_Hand
{
    var mc, baseMC, mInfo, lineArray, nowLine;
    function ETF_Hand(_tmc)
    {
        trace ("ETF_Hand");
        mc = _tmc;
        baseMC = mc.hanjaCon_mc;
        //mInfo初始化信息
        mInfo = {isDrawing: false, minGap: mc.minGap || 8, thick: mc.lineThick || 5, color: mc.lineColor || 16711680, allOut: mc.useAllOutput == undefined ? ("true") : (String(mc.useAllOutput).toLowerCase()), mode: mc.mode || "en", isDescShow: true, isFieldOver: false};
        trace ("--mInfo begin--");
        trace ("mInfo.isDrawing:"+mInfo.isDrawing);
        trace ("mInfo.minGap:"+mInfo.minGap);
        trace ("mInfo.thick:"+mInfo.thick);
        trace ("mInfo.color:"+mInfo.color);
        trace ("mInfo.allOut:"+mInfo.allOut);
        trace ("mInfo.mode:"+mInfo.mode);
        trace ("mInfo.isDescShow:"+mInfo.isDescShow);
		trace ("mInfo.isFieldOver:"+mInfo.isFieldOver);
        trace ("--mInfo end--");
        lineArray = [];
        nowLine = new Object();
        this.field_setInit();
        flash.external.ExternalInterface.addCallback("callData", null, Delegate.create(this, sendData));
        flash.external.ExternalInterface.addCallback("clearData", null, Delegate.create(this, clearHanjaCon));
    } // End of the function
    function sendData()
    {
    	trace ("sendData");
        flash.external.ExternalInterface.call("ETF_swfHand_show", this.showLineInfo());
		trace ("showLineInfo():"+this.showLineInfo());
    } // End of the function
    function field_setInit()
    {
        trace ("field_setInit");
        trace ("mInfo.mode:"+mInfo.mode);
        mc.desc_mc.gotoAndStop(mInfo.mode);
        mc.undo_btn.gotoAndStop(mInfo.mode);
        mc.clear_btn.gotoAndStop(mInfo.mode);
        var _loc2 = new Object(this);
        /*
        当鼠标移动时获得通知。若要使用 onMouseMove 侦听器，您必须创建一个侦听器对象。然后可以为 onMouseMove 定义一个函数，并使用 addListener() 注册含有 Mouse 对象的侦听器
        如以下代码所示：
var someListener:Object = new Object();
someListener.onMouseMove = function () { ... };
Mouse.addListener(someListener);
        */
        _loc2.onMouseMove = Delegate.create(this, fieldMove);
        Mouse.addListener(_loc2);
        //mc.area_mc.useHandCursor = false;//布尔值，当设置为 true（默认值）时，表示鼠标指针滑过按钮上方时是否显示手指形（手形光标）。如果此属性设置为 false，则将改用箭头指针。
        mc.area_mc.onRollOver = Delegate.create(this, fieldOver);//当鼠标指针移过按钮区域时调用。必须定义一个在调用事件处理函数时执行的函数。
        mc.area_mc.onRollOut = Delegate.create(this, fieldOut);//当鼠标指针移至按钮区域之外时调用。必须定义一个在调用事件处理函数时执行的函数。
        mc.area_mc.onPress = Delegate.create(this, fieldPress);//当按下按钮时调用。必须定义一个在调用事件处理函数时执行的函数。
        mc.area_mc.onRelease = Delegate.create(this, fieldRelease);//当释放按钮时调用。必须定义一个在调用事件处理函数时执行的函数。
        mc.area_mc.onReleaseOutside = mc.area_mc.onDragOut = Delegate.create(this, fieldRelease);//在这样的情况下调用：在鼠标指针位于按钮内部的情况下按下按钮，然后将鼠标指针移到该按钮外部并释放鼠标按键。必须定义一个在调用事件处理函数时执行的函数。
        mc.undo_btn.onRelease = Delegate.create(this, undo);
        mc.clear_btn.onRelease = Delegate.create(this, clearHanjaCon);
    } // End of the function
    function fieldOver()
    {
        trace ("fieldOver");
        trace (mInfo.isDescShow + ":" + mc.desc_mc);
        if (mInfo.isDescShow)
        {
            mInfo.isDescShow = false;
            mc.desc_mc._visible = false;
        } // end if
        Mouse.hide();
        mc.pen_mc._visible = true;
        mInfo.isFieldOver = true;
    } // End of the function
    function fieldOut()
    {
        trace ("fieldOut");
        Mouse.show();
        mc.pen_mc._visible = false;
        mInfo.isFieldOver = false;
        this.fieldRelease();
    } // End of the function
    function fieldPress()
    {
        trace ("fieldPress");
        mInfo.isDrawing = true;
        this.drawLine(mc._xmouse, mc._ymouse, true);
    } // End of the function
    function fieldRelease()
    {
        trace ("fieldRelease");
        if (mInfo.isDrawing)
        {
            mInfo.isDrawing = false;
            this.lineFinish();
        } // end if
    } // End of the function
    function fieldMove()
    {
        //trace ("fieldMove");
        if (mInfo.isFieldOver)
        {
            mc.pen_mc._x = mc._xmouse;
            mc.pen_mc._y = mc._ymouse;
        } // end if
        if (mInfo.isDrawing)
        {
            this.drawLine(mc._xmouse, mc._ymouse, false);
        } // end if
    } // End of the function
    function cutLine()
    {
        trace ("cutLine");
        if (mInfo.isDrawing)
        {
            mInfo.isDrawing = false;
            this.lineFinish();
        } // end if
    } // End of the function
    function drawLine(nX, nY, isStart)
    {
        trace ("drawLine");
        if (isStart)
        {
            var _loc6 = baseMC.getNextHighestDepth();
            nowLine.mc = baseMC.createEmptyMovieClip("line" + _loc6, _loc6);
            nowLine.mc.lineStyle(mInfo.thick, mInfo.color, 100);
            nowLine.mc.moveTo(nX, nY);
            nowLine.x = [];
            nowLine.y = [];
            nowLine.x.push(nX);
            nowLine.y.push(nY);
        }
        else
        {
            var _loc5 = nowLine.x[nowLine.x.length - 1] - nX;
            var _loc4 = nowLine.y[nowLine.y.length - 1] - nY;
            if (Math.sqrt(_loc5 * _loc5 + _loc4 * _loc4) >= mInfo.minGap)
            {
                nowLine.mc.lineTo(nX, nY);
                nowLine.x.push(nX);
                nowLine.y.push(nY);
            } // end if
        } // end else if
    } // End of the function
    function lineFinish()
    {
        trace ("lineFinish");
        var _loc3 = nowLine.x.length;
        if (_loc3 > 1)
        {
            var _loc4 = "=S " + _loc3 + "\n";
            for (var _loc2 = 0; _loc2 < _loc3; ++_loc2)
            {
                _loc4 = _loc4 + (nowLine.x[_loc2] + " " + nowLine.y[_loc2] + " ");
            } // end of for
            lineArray[lineArray.length] = [];
            lineArray[lineArray.length - 1].str = _loc4;
            lineArray[lineArray.length - 1].mc = nowLine.mc;
            if (mInfo.allOut == "true")
            {
                this.sendData();
            } // end if
        } // end if
    } // End of the function
    function showLineInfo()
    {
        trace ("showLineInfo");
        var _loc3 = lineArray.length;
        var _loc4 = "=R " + _loc3 + "\n";
        for (var _loc2 = 0; _loc2 < _loc3; ++_loc2)
        {
            _loc4 = _loc4 + (lineArray[_loc2].str + "\n");
        } // end of for
        return (_loc4);
    } // End of the function
    function clearHanjaCon()
    {
        trace ("clearHanjaCon");
        for (var _loc2 in baseMC)
        {
            baseMC[_loc2].removeMovieClip();
        } // end of for...in
        lineArray = [];
        flash.external.ExternalInterface.call("ETF_swfHand_clear", this.showLineInfo());
    } // End of the function
    function undo()
    {
        trace ("undo");
        if (lineArray.length > 0)
        {
            lineArray[lineArray.length - 1].mc.removeMovieClip();
            lineArray.splice(lineArray.length - 1, 1);
            if (mInfo.allOut == "true")
            {
                this.sendData();
            } // end if
        } // end if
    } // End of the function
} // End of Class
