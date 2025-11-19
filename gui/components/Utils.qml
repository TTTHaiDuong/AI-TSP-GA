pragma Singleton
import QtQuick

QtObject {
    // Các object qml không sử dụng forEach như mảng js
    function forEach(arr, func) {
        for (let i = 0; i < arr.length; i++)
            func(arr[i], i);
    }

    function flattenDeep(arr) {
        var res = [];
        for (var i = 0; i < arr.length; i++) {
            if (Array.isArray(arr[i])) {
                res = res.concat(flattenDeep(arr[i]));
            } else {
                res.push(arr[i]);
            }
        }
        return res;
    }

    function findMaxND(arr) {
        let maxVal = -Infinity;
        let maxPos = [];

        function recurse(subArr, path) {
            if (!Array.isArray(subArr)) {
                if (subArr > maxVal) {
                    maxVal = subArr;
                    maxPos = path.slice();
                }
                return;
            }
            for (let i = 0; i < subArr.length; i++) {
                recurse(subArr[i], path.concat(i));
            }
        }

        recurse(arr, []);
        return {
            maxVal,
            maxPos
        };
    }
}
