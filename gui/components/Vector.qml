pragma Singleton
import QtQuick

QtObject {
    function fromPoints(p1, p2) {
        return this.sub(p2, p1);
    }

    function add(v1, v2) {
        return {
            x: v1.x + v2.x,
            y: v1.y + v2.y
        };
    }

    function sub(v1, v2) {
        return {
            x: v1.x - v2.x,
            y: v1.y - v2.y
        };
    }

    function scale(v, scalar) {
        return {
            x: v.x * scalar,
            y: v.y * scalar
        };
    }

    function dot(v1, v2) {
        return v1.x * v2.x + v1.y * v2.y;
    }

    function length(v) {
        return Math.sqrt(v.x * v.x + v.y * v.y);
    }

    function normalize(v) {
        const len = this.length(v);
        return {
            x: v.x / len,
            y: v.y / len
        };
    }

    function angle(v) {
        return Math.atan2(v.y, v.x);
    }
}
