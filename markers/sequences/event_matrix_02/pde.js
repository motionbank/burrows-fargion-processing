/**
 *    Analogous to int(), float(), str(), ... it will produce an Object from it's input.
 *
 *    object( "<json string>" ) -> Object
 *    object( k1, v1, k2, v2, ... ) -> Object { k1: v1, k2: v2 }
 */
var object = function () {
    var obj = {};
    if ( arguments.length == 1 && typeof arguments[0] == 'string' ) {
        obj = eval( '(' + arguments[0] + ')' );
    } else if ( arguments.length > 1 && (function is_even(l){return l/2 == l/2.0})(arguments.length) ) {
        for ( var i = 0, a = arguments.length; i < a; i+=2 ) {
            obj[arguments[i]] = arguments[i+1];
        }
    }
    return obj;
};

/**
 *    Handy sorting of ArrayLists in a Java-sane syntax.
 */
var Collections = {
    sort: function ( list, comparator ) {
        var arr = list.toArray();
        if ( comparator )
            arr.sort(comparator.compare);
        else
            arr.sort();
        list.clear();
        list.addAll(arr);
    }
};

/**
 *    Mimik Arrays.sort()
 */
var Arrays = {
    sort: function ( arr, comparator ) {
        if ( comparator )
            arr.sort( comparator.compare );
        else
            arr.sort();
    }
}
