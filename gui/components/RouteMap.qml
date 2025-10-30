import QtCharts
import QtQuick

ChartView {
    id: root
    property string title
    antialiasing: true
    legend.visible: false
    
    // Series để vẽ các thành phố (dạng điểm)
    ScatterSeries {
        id: citySeries
        markerSize: 10
        color: "steelblue"
    }

    // Series để vẽ lộ trình (dạng đường nối)
    LineSeries {
        id: routeSeries
        color: "tomato"
        width: 2
    }
    
    // Hàm xóa bản đồ
    function clear() {
        citySeries.clear();
        routeSeries.clear();
    }
    
    // Hàm vẽ các thành phố
    function drawNodes(nodes) {
        citySeries.clear();
        for (var i = 0; i < nodes.length; i++) {
            citySeries.append(nodes[i].x, nodes[i].y);
        }
        // Tự động điều chỉnh view cho vừa các điểm
        root.zoomToFit(nodes);
    }
    
    // Hàm vẽ lộ trình
    function drawRoute(route) {
        routeSeries.clear();
        for (var i = 0; i < route.length; i++) {
            routeSeries.append(route[i].x, route[i].y);
        }
        // Nối điểm cuối với điểm đầu
        if (route.length > 0) {
            routeSeries.append(route[0].x, route[0].y);
        }
    }
    
    // Hàm helper để zoom vừa khít các điểm
    function zoomToFit(points) {
        if (points.length === 0) return;
        
        var minX = points[0].x, maxX = points[0].x;
        var minY = points[0].y, maxY = points[0].y;
        
        for (var i = 1; i < points.length; i++) {
            if (points[i].x < minX) minX = points[i].x;
            if (points[i].x > maxX) maxX = points[i].x;
            if (points[i].y < minY) minY = points[i].y;
            if (points[i].y > maxY) maxY = points[i].y;
        }

        var paddingX = (maxX - minX) * 0.1;
        var paddingY = (maxY - minY) * 0.1;
        
        axisX.min = minX - paddingX;
        axisX.max = maxX + paddingX;
        axisY.min = minY - paddingY;
        axisY.max = maxY + paddingY;
    }
}