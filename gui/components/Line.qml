pragma Singleton
import QtQuick

QtObject {
    function distanceToPoint(line, P) {
        var A = line.point1;
        var B = line.point2;

        var vAP = Vector.fromPoints(A, P);
        var vAB = Vector.fromPoints(A, B);

        var t = Vector.dot(vAP, vAB) / (vAB.x * vAB.x + vAB.y * vAB.y);
        var Q = Vector.add(A, Vector.scale(vAB, t));

        var vPQ = Vector.fromPoints(P, Q);
        return Vector.length(vPQ);
    }

    function midPoint(p1, p2) {
        return {
            x: (p1.x + p2.x) / 2,
            y: (p1.y + p2.y) / 2
        };
    }
}
