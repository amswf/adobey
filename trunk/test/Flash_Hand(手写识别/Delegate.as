class Delegate extends Object
{
    var func;
    function Delegate(f)
    {
        super();
        func = f;
    } // End of the function
    static function create(obj, func)
    {
        var _loc2 = function ()
        {
            var _loc3 = arguments.callee.target;
            var _loc4 = arguments.callee.func;
            var _loc2 = arguments.concat(arguments.callee.args);
            _loc2.callee = arguments.callee;
            _loc2.caller = arguments.caller;
            return (_loc4.apply(_loc3, _loc2));
        };
        _loc2.target = obj;
        _loc2.func = func;
        _loc2.args = arguments.splice(2);
        return (_loc2);
    } // End of the function
    function createDelegate(obj)
    {
        return (Delegate.create(obj, func));
    } // End of the function
} // End of Class
