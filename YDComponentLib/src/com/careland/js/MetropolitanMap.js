
var MetropolitanMap = {

    routePresetData: [], //预规划线路数据
    curFLID: 0, //真实火炬当前垂足线ID号，用于对比避免往回走
    backFLID: 0, //轨迹回放当前垂足线ID号，用于对比避免往回走
    mainId: null, //地图数据
    loadData: function(xml, divId, id) {
        var datas = xml.selectNodes("datas/table");
        if (datas == null || datas.length <= 0) {
            alert("数据异常");
            return;
        }
        mainId = divId;
        var mainDiv = document.getElementById(divId);
        var type = datas[0].selectNodes("data")[0].getAttribute("区分标识");
        switch (type) {
            case "currentLocation":
                this.setCurrentLocation(xml, mainDiv, id);
                break;
            case "routePresetLine":
                this.loadLine(xml, mainDiv, id);
                break;
            case "pointLinePolygon":
                this.metropolitanMap(xml, mainDiv, id);
                break;
            case "playBack":
                this.playBack(xml, mainDiv, id);
            default:
                break;
        }


    },
    loadBackGround: function(data0, mainDiv, id) {
        var div = writeWindow("backGroundDiv", "");
        var html = "<input type='button' style='float:right;margin-top:300px' value='清除所有图层' onclick='MetropolitanMap.clearAll()'>";
        div.innerHTML = html;
        div.style.background = "url(" + data0.getAttribute("背景图片路径") + ")";
        div.style.width = data0.getAttribute("背景图片宽度") + "px";
        div.style.height = data0.getAttribute("背景图片高度") + "px";
        div.style.display = "";

        var mydiv = writeWindow("backGroundDiv_" + id, "");
        mydiv.style.display = "";
        mydiv.innerHTML = "";
        div.appendChild(mydiv);
        mainDiv.appendChild(div);
    },
    metropolitanMap: function(xml, mainDiv, id) {
        var datas = xml.selectNodes("datas/table");
        if (datas.length <= 0) {
            alert("数据异常");
            return;
        }
        var data0 = datas[1].selectNodes("data")[0];
        this.loadBackGround(data0, mainDiv, id);
        var data = datas[2].selectNodes("data");
        var mydiv = document.getElementById("backGroundDiv_" + id);
        for (var k = 0; k < data.length; k++) {
            if (data[k].getAttribute("鼠标经过数据") != "") {
                var html = "<div id='tipsWin_" + data[k].getAttribute("ID") + "' style='display:none;' class='tipsWin'>";
                html += "<div  class='tipsWinTop'>";
                html += "<div class='tipsWinTop_left'></div>";
                html += "<div class='tipsWinTop_mid'></div>";
                html += "<div class='tipsWinTop_right'></div>";
                html += "</div>";
                html += "<div class='tipsWinMid'>";
                html += "<div class='tipsWinMid_left'></div>";
                html += "<div class='tipsWinMid_mid'>" + data[k].getAttribute("鼠标经过数据") + "</div>";
                html += "<div class='tipsWinMid_right'></div>";
                html += "</div>";
                html += "<div class='tipsWinBottom'>";
                html += "<div class='tipivsWinBottom_left'></div>";
                html += "<div class='tipsWinBottom_mid'></div>";
                html += "<div class='tipsWinBottom_right'></div>";
                html += "</div>";
                html += "</div>";
                var tipDiv = document.createElement("div");
                tipDiv.style.zIndex = "999";
                tipDiv.innerHTML = html;
                tipDiv.index = "point_line_polygon_clear_" + id;
                mydiv.appendChild(tipDiv);
            }
            switch (data[k].getAttribute("类型")) {
                case "point":
                    var div = document.createElement("div");
                    div.tipId = "tipsWin_" + data[k].getAttribute("ID");
                    div.id = "point_" + data[k].getAttribute("ID");
                    //div.index = "point_line_polygon_clear_" + id
                    div.style.width = data[k].getAttribute("宽度");
                    div.style.height = data[k].getAttribute("高度")
                    div.style.zIndex = 100;
                    div.windowID = data[k].getAttribute("弹出窗信息");
                    div.style.backgroundImage = "url(" + data[k].getAttribute("标注图片") + ")";
                    div.style.position = "absolute";
                    var pointxy = data[k].getAttribute("坐标");
                    if (data[k].getAttribute("坐标类型") == 1) {
                        var point = new Point(pointxy.split(",")[0], pointxy.split(",")[1], data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
                        var sp = point.toScreenPoint(data0.getAttribute("地图级别"));
                        div.style.left = sp.x - (data[k].getAttribute("宽度") / 2);
                        div.style.top = sp.y - (data[k].getAttribute("高度") / 2);
                    }
                    else {
                        div.style.left = pointxy.split(",")[0] - (data[k].getAttribute("宽度") / 2);
                        div.style.top = pointxy.split(",")[0] - (data[k].getAttribute("高度") / 2);
                    }
                    if (data[k].getAttribute("鼠标经过数据") != "") {
                        div.onmouseover = function() { MetropolitanMap.onMouseOver(this) };
                        div.onmouseout = function() { MetropolitanMap.onMouseOut(this) };
                    }
                    if (div.windowID) {
                        div.onclick = function() { eval(this.windowID) };
                    }
                    mydiv.appendChild(div);
                    break;
                case "polyLine":
                    var routeWidth = data[k].getAttribute("线宽度");    //线宽度
                    var routeColor = data[k].getAttribute("线颜色");
                    var routeStyle = data[k].getAttribute("线样式");
                    var opatity = data[k].getAttribute("透明度");
                    var points = data[k].getAttribute("坐标");
                    var div = document.createElement("div");
                    div.tipId = "tipsWin_" + data[k].getAttribute("ID");
                    div.windowID = data[k].getAttribute("弹出窗信息");
                    div.id = "polyLine_" + data[k].getAttribute("ID");
                    //div.index = "point_line_polygon_clear_" + id
                    div.style.zIndex = "0";
                    if (data[k].getAttribute("鼠标经过数据") != "") {
                        div.onmouseover = function() { MetropolitanMap.onMouseOver(this) };
                        div.onmouseout = function() { MetropolitanMap.onMouseOut(this) };
                    }
                    if (div.windowID) {
                        div.onclick = function() { eval(this.windowID) };
                    }

                    var screenPoints = "";
                    if (data[k].getAttribute("坐标类型") == 1) {
                        var point = points.split(";");
                        for (var p = 0; p < point.length; p++) {
                            var screenPoint = new Point(point[p].split(",")[0], point[p].split(",")[1], data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
                            var sp = screenPoint.toScreenPoint(data0.getAttribute("地图级别"));
                            if (screenPoints == '') {
                                screenPoints = sp.x + "," + sp.y;
                            }
                            else {
                                screenPoints = screenPoints + ";" + sp.x + "," + sp.y;
                            }
                        }
                    }
                    else {
                        screenPoints = points;
                    }
                    div.innerHTML = createRounte(data[k].getAttribute("ID"), routeColor, routeWidth, routeStyle, opatity, screenPoints, 0)
                    mydiv.appendChild(div);
                    break;
                case "polygon":
                    var points = data[k].getAttribute("坐标");
                    var point = points.split(";");
                    var screenPoints = "";
                    var px1 = 0;
                    var py1 = 0;
                    if (data[k].getAttribute("坐标类型") == 1) {
                        for (var p = 0; p < point.length; p++) {
                            var screenPoint = new Point(point[p].split(",")[0], point[p].split(",")[1], data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
                            var sp = screenPoint.toScreenPoint(data0.getAttribute("地图级别"));
                            if (screenPoints == '') {
                                px1 = sp.x;
                                py1 = sp.y;
                                screenPoints = 0 + "," + 0;
                            }
                            else {
                                screenPoints = screenPoints + ";" + (sp.x - px1) + "," + (sp.y - py1);
                            }
                        }
                    }
                    else {
                        screenPoints = points;
                    }
                    var div = document.createElement("div");
                    div.tipId = "tipsWin_" + data[k].getAttribute("ID");
                    div.id = "polygon_" + data[k].getAttribute("ID");
                    //div.index = "point_line_polygon_clear_" + id
                    div.myId = data[k].getAttribute("ID");
                    div.isUplift = data[k].getAttribute("面是否隆起");
                    div.windowID = data[k].getAttribute("弹出窗信息");
                    div.innerHTML = createFace(data[k].getAttribute("ID"), screenPoints, data[k].getAttribute("面填充颜色"), data[k].getAttribute("面边框颜色"), data[k].getAttribute("面边框宽度"), data[k].getAttribute("透明度"));
                    div.style.position = "absolute";
                    div.style.left = px1;
                    div.style.top = py1;
                    div.onmouseover = function() { MetropolitanMap.onMouseOver(this); if (this.isUplift == "True") { hotOver(this.myId, px1, py1); } };
                    div.onmouseout = function() { MetropolitanMap.onMouseOut(this); if (this.isUplift == "True") { hotOut(this.myId); } };
                    if (div.windowID) {
                        div.onclick = function() { eval(this.windowID) };
                    }
                    mydiv.appendChild(div);
                    break;
                default:
                    break;
            }
        }
    },
    //加载预规划线路
    loadLine: function(xml, mainDiv, id) {
        var datas = xml.selectNodes("datas/table");
        if (datas == null || datas.length <= 0) {
            alert("数据异常");
            return;
        }
        var data0 = datas[1].selectNodes("data")[0];
        this.loadBackGround(data0, mainDiv, id);
        var data = datas[2].selectNodes("data")[0];
        var myDiv = document.getElementById("backGroundDiv_" + id);
        //绘制火炬传递路线
        routePresetData = [];
        var routeWidth = data.getAttribute("线宽度");    //线宽度
        var routeColor = data.getAttribute("线颜色");
        var routeStyle = data.getAttribute("线样式");
        var opatity = data.getAttribute("透明度");
        var points = data.getAttribute("坐标");

        var div = document.createElement("div");
        div.id = "initRouteDIV";
        //div.index = "point_line_polygon_clear_" + id;
        div.style.zIndex = "0";
        var screenPoints = "";
        var point = points.split(";");
        if (data.getAttribute("坐标类型") == 1) {
            for (var p = 0; p < point.length; p++) {
                var screenPoint = new Point(point[p].split(",")[0], point[p].split(",")[1], data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
                var sp = screenPoint.toScreenPoint(data0.getAttribute("地图级别"));
                if (screenPoints == '') {
                    screenPoints = sp.x + "," + sp.y;
                }
                else {
                    screenPoints = screenPoints + ";" + sp.x + "," + sp.y;
                }
                routePresetData.push({ initID: p, x: sp.x, y: sp.y });
            }
        }
        else {
            screenPoints = points;
            for (var p = 0; p < point.length; p++) {
                routePresetData.push({ initID: p, x: parseInt(point[p].split(",")[0]), y: parseInt(point[p].split(",")[1]) });
            }
        }
        div.innerHTML = createRounte(data.getAttribute("ID"), routeColor, routeWidth, routeStyle, opatity, screenPoints, 1)
        myDiv.appendChild(div);
        //mainDiv.appendChild(div);
    },

    //移动目标
    setCurrentLocation: function(xml, mainDiv, id) {
        var datas = xml.selectNodes("datas/table");
        if (datas == null || datas.length <= 0) {
            alert("数据异常");
            return;
        }
        var data0 = datas[1].selectNodes("data")[0];
        var data = datas[2].selectNodes("data")[0];
        this.loadBackGround(data0, mainDiv, id);
        var myDiv = document.getElementById("backGroundDiv_" + id);
        if (data) {
            var isFinish = data.getAttribute("是否已完成");
            var div = document.getElementById("RouteDIV");
            if (!div) {
                div = document.createElement("div");
                div.id = "RouteDIV";
                //div.name = "point_line_polygon_clear_" + id
                div.style.zIndex = "10";
            }
            var routeWidth = data0.getAttribute("线路宽度");    //线宽度
            var routeColor = data0.getAttribute("线路颜色"); //线颜色
            var imgPath = data0.getAttribute("图片路径");
            var imgWidth = data0.getAttribute("图片宽度");
            var imgHeight = data0.getAttribute("图片高度");
            var routeStyle = "solid";
            var opatity = 90;
            var polylinePoints = routePresetData[0].x + "," + routePresetData[0].y;
            if (isFinish == "1") {
                for (var i = 1; i < routePresetData.length; i++) {
                    polylinePoints += ";" + routePresetData[i].x + "," + routePresetData[i].y;
                }
                div.innerHTML = createRounte("RouteDIV0001", routeColor, routeWidth, routeStyle, opatity, polylinePoints, 2, routePresetData[routePresetData.length - 1].x, routePresetData[routePresetData.length - 1].y, imgPath, imgWidth, imgHeight);
            }
            else {
                var curPointX = data.getAttribute("经度");
                var curPointY = data.getAttribute("纬度");
                var screenPoint = new Point(curPointX, curPointY, data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
                var sp = screenPoint.toScreenPoint(data0.getAttribute("地图级别"));
                var footArr = getShortVerticalFoot(sp.x, sp.y);

                //==========有垂足时启动动画 BEG==========
                if (footArr != null && footArr != "") {
                    //如果当前垂足ID小于目标ID则直接跳过
                    if (footArr.initID < this.curFLID) return;
                    for (var l = 0; l <= footArr.initID; l++) {
                        if (l == footArr.initID) {
                            polylinePoints += ";" + footArr.x + "," + footArr.y;
                        } else {
                            polylinePoints += ";" + routePresetData[l + 1].x + "," + routePresetData[l + 1].y;
                        }
                    }
                    sp.x = footArr.x;
                    sp.y = footArr.y;
                    div.innerHTML = createRounte("RouteDIV0001", routeColor, routeWidth, routeStyle, opatity, polylinePoints, 2, sp.x, sp.y, imgPath, imgWidth, imgHeight);
                    this.curFLID = footArr.initID;
                }

            }
            myDiv.appendChild(div);
            //mainDiv.appendChild(myDiv);
        }
    },
    playBack: function(xml, mainDiv, id) {
        var datas = xml.selectNodes("datas/table");
        if (datas == null || datas.length <= 0) {
            alert("数据异常");
            return;
        }
        var data0 = datas[1].selectNodes("data")[0];
        var data = datas[2].selectNodes("data")[0];
        this.loadBackGround(data0, mainDiv, id);
        var myDiv = document.getElementById("backGroundDiv_" + id);
        if (data) {
            var div = document.getElementById("RouteBackDIV");
            if (!div) {
                div = document.createElement("div");
                div.id = "RouteBackDIV";
                //div.name = "point_line_polygon_clear_" + id
                div.style.zIndex = "10";
            }
            var routeWidth = data0.getAttribute("线路宽度");    //线宽度
            var routeColor = data0.getAttribute("线路颜色"); //线颜色
            var imgPath = data0.getAttribute("图片路径");
            var imgWidth = data0.getAttribute("图片宽度");
            var imgHeight = data0.getAttribute("图片高度");
            var routeStyle = "solid";
            var opatity = 90;
            var polylinePoints = routePresetData[0].x + "," + routePresetData[0].y;

            var curPointX = data.getAttribute("经度");
            var curPointY = data.getAttribute("纬度");
            var screenPoint = new Point(curPointX, curPointY, data0.getAttribute("左顶点经度"), data0.getAttribute("左顶点纬度"), data0.getAttribute("背景图片宽度"), data0.getAttribute("背景图片高度"));
            var sp = screenPoint.toScreenPoint(data0.getAttribute("地图级别"));
            var footArr = getShortVerticalFoot(sp.x, sp.y);

            //==========有垂足时启动动画 BEG==========
            if (footArr != null && footArr != "") {
                //如果当前垂足ID小于目标ID则直接跳过
                if (footArr.initID < this.backFLID) return;
                for (var l = 0; l <= footArr.initID; l++) {
                    if (l == footArr.initID) {
                        polylinePoints += ";" + footArr.x + "," + footArr.y;
                    } else {
                        polylinePoints += ";" + routePresetData[l + 1].x + "," + routePresetData[l + 1].y;
                    }
                }
                sp.x = footArr.x;
                sp.y = footArr.y;
                div.innerHTML = createRounte("RouteBackDIV0001", routeColor, routeWidth, routeStyle, opatity, polylinePoints, 2, sp.x, sp.y, imgPath, imgWidth, imgHeight);
                this.backFLID = footArr.initID;
            }
            myDiv.appendChild(div);
            //mainDiv.appendChild(myDiv);
        }
    },
    //根据图层ID删除上面所有元素
    clearById: function(id) {
        var p = document.getElementById("backGroundDiv_" + id);
        if (p) {
            p.innerHTML = "";
        }
    },
    //删除所有元素
    clearAll: function() {
        var p = document.getElementById("backGroundDiv");
        if (p) {
            p.innerHTML = "<input type='button' style='float:right;margin-top:300px' value='清除所有图层' onclick='MetropolitanMap.clearAll()'>";
        }
    },
    onMouseOver: function(obj) {
        var tip = document.getElementById(obj.tipId);
        if (tip) {
            var x = event.x;
            var y = event.y;
            tip.style.display = "block";
            tip.style.top = y;
            tip.style.left = x;
        }
    },
    onMouseOut: function(obj) {
        var tmp = document.getElementById(obj.tipId);
        if (tmp) {
            tmp.style.display = "none";
        }
    }
}

//==================================================================================================================================
//==========================================================经纬度转换 BEG==========================================================
//==================================================================================================================================
/**
坐标函数
114.05597,22.54668
570,350
1.3360737143096994
668.87966032762574952022114729226
651,156


114.05692,22.54428
540,410
1.4347989087575128
678.01179930735718723497580272567
672,92
*/
function Point(x, y, mx, my, imageWidth, imageHeight) {
    this.mapWidth = imageWidth;
    this.mapHeight = imageHeight;
    //深大传递
    this.mapX = mx;  //113.9187972;  //莲花山传递：114.0265452
    this.mapY = my; //22.53606111;   //莲花山传递：22.55013
    this.scalewidth = 0.0000452;
    this.scaleheight = 0.0000375;
    this.x = Number(x);
    this.y = Number(y);
}

Point.prototype.toScreenPoint = function(zoomPro) {
    var x = (this.x - this.mapX) / this.scalewidth;
    var y = (this.mapY - this.y) / this.scaleheight;

    // 算出角度
    var l = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
    var a = Math.atan(x / y) * 180 / Math.PI;
    var r = a;

    // 旋转45度角
    if (a >= 0) {
        a = (a - 46);
    }
    else {
        a = 180 + a - 47;
    }
    a = a * Math.PI / 180;
    x = l * Math.sin(a);
    y = l * Math.cos(a);

    //缩放比例
    //var zoomPro = 1.32;
    //var zoomPro = 2.048;

    //偏移量
    //    var offX = -85;
    //    var offY = 50;
    var offX = -5;
    var offY = 65;

    offX += x / 2 + 25;
    offY += 0.000543859649122807017543859649123 * y;

    // 加偏移量
    x = x * zoomPro + offX;
    y = y * zoomPro - offY;

    return { x: Math.floor(x), y: Math.floor(y), offX: Math.floor(offX), offY: Math.floor(offY) };
};
//==================================================================================================================================
//==========================================================经纬度转换 END==========================================================
//==================================================================================================================================

//按照参数画面并绑定面动作和数据
//参数：面编号,点集合,信息,附加参数,其它）
function createFace(faceID, points, fillColor, borderColor, borderSize, opacity) {
    var f = "";
    var f = "<v:polyline id='face_" + faceID + "' style='LEFT:0px;POSITION:absolute; z-index:5;TOP:0px;filter:Alpha(opacity=" + opacity + ");' points='" + points + "' strokecolor='" + borderColor + "' strokeweight='" + borderSize + "px' coordsize='100,100' fillcolor='" + fillColor + "'> "
        + " <v:extrusion id='bottom_" + faceID + "' on='t' foredepth='0pt' backdepth='0pt' color='" + fillColor + "' diffusity='72089f' skewangle='135'/>"
        + " </v:polyline>";
    return f;
}
//画线

function createRounte(lineID, lineColor, routeWidth, lineStyle, opactity, polylinePoints, isRount, x, y,imgPath,imgWidth,imgHeight) {
    var line = "<v:polyline id=\"line_" + lineID + "\" style=\"Z-INDEX:5;FILTER:alpha(opacity=" + opactity + ",style=0);LEFT:0;TOP:0\" points=\"" + polylinePoints + "\" filled=\"f\" stroked=\"t\" strokecolor=\"" + lineColor + "\" strokeweight=\"" + routeWidth + "\">";
    if (isRount == 1) {
        line += "<v:stroke opacity=\"1\" startarrow=\"oval\" startarrowwidth=\"narrow\" startarrowlength=\"short\" endarrow=\"classic\" endarrowwidth=\"narrow\" endarrowlength=\"short\"/>";
    }
    else if (isRount == 2) {
        line += "<v:stroke opacity=\"1\" startarrow=\"oval\" startarrowwidth=\"narrow\" startarrowlength=\"short\" endarrow=\"classic\" endarrowwidth=\"narrow\" endarrowlength=\"short\"/>";
    }
    line += "</v:polyline>";
    if (isRount == 2) {
        line += "<v:Image id=\"torchIMG\" style=\"Z-INDEX:100;WIDTH:"+imgWidth+";HEIGHT:"+imgHeight+";LEFT:" + (x-imgWidth/2) + ";TOP:" + (y - imgHeight+5) + ";\" src=\"" + imgPath + "\" bilevel=\"f\"/>";
    }
    return line;
}


//热点区域面效果控制
// 鼠标经过面是有升起效果
var hotStopUp;
function hotOver(faceId, left, top) {
    var face = document.getElementById("face_" + faceId);
    var face2 = document.getElementById("bottom_" + faceId);
    var at = parseInt(face2.backdepth);
    var le = parseInt(face2.foredepth);
    if (at < 10) {
        face.style.zIndex = parseInt(face.style.zIndex) + 100;
        face.style.top = 0 - at + 3;
        face.style.left = 0 - at + 3;
        face2.backdepth = (at + 4) + "px";
        face2.foredepth = (le + 4) + "px";
        hotStopUp = setTimeout("hotOver( " + faceId + "," + faceId + "," + left + "," + top + ")", 100);
    } else {
        return;
    }
}

//鼠标离开时面复位
function hotOut(faceId) {
    var face = document.getElementById("face_" + faceId);
    var face2 = document.getElementById("bottom_" + faceId);
    clearTimeout(hotStopUp);
    face.style.top = 0;
    face.style.left = 0;
    face2.backdepth = 0;
    face2.foredepth = 0;
    face.style.zIndex = 5;
}

//==================================================================================================================================
//===========================================================公共函数 BEG===========================================================
//==================================================================================================================================

//获取点到线的垂足,有返回坐标,没有则返回null
//Ax,Ay 已知直线A端点坐标
//Bx,By 已知直线B端点坐标
//Cx,Cy 已知直线外点坐标
//返回null,或者垂足坐标
function getVerticalFoot(Ax, Ay, Bx, By, Cx, Cy) {
    var Dx, Dy;  //求:已知点到已知直线的垂足坐标

    Dx = parseInt([Cx * ((Ax - Bx) * (Ax - Bx)) + (Bx * (-Cy + Ay) + Ax * (Cy - By)) * (Ay - By)] / (Ax * Ax - 2 * Ax * Bx + Bx * Bx + (Ay - By) * (Ay - By)));
    Dy = parseInt((Bx * Bx * Ay + Cy * Ay * Ay + Cx * (Ax - Bx) * (Ay - By) + Ax * Ax * By - 2 * Cy * Ay * By + Cy * By * By - Ax * Bx * (Ay + By)) / (Ax * Ax - 2 * Ax * Bx + Bx * Bx + ((Ay - By) * (Ay - By))));

    //判断点是否在线上,不在则证明没有垂直相交线
    var lac = Math.sqrt((Ax - Dx) * (Ax - Dx) + (Ay - Dy) * (Ay - Dy));
    var lbc = Math.sqrt((Bx - Dx) * (Bx - Dx) + (By - Dy) * (By - Dy));
    var lab = Math.sqrt((Ax - Bx) * (Ax - Bx) + (Ay - By) * (Ay - By));
    if (lac + lbc < lab + 0.05) {
        return { x: Dx, y: Dy };
    } else {
        return null;
    }
}

//计算两点间的距离,返回距离数值
//AxAy为直线端点A的坐标
//BxBy为直线端点B的坐标
function getPointDistance(Ax, Ay, Bx, By) {
    var xdiff = Bx - Ax;
    var ydiff = By - Ay;
    return Math.pow((xdiff * xdiff + ydiff * ydiff), 0.5);
}

//小数点截取
//src:输入数字
//pos:保留位数
function formatFloat(src, pos) {
    return Math.round(src * Math.pow(10, pos)) / Math.pow(10, pos);
}

//按照当前坐标算出在路面最近位置（垂足）,传入X,Y,返回原始ID.距离.坐标(X,Y)数组
function getShortVerticalFoot(curPointX, curPointY) {

    //==========对数组排序得出最短垂足 BEG==========
    var i = MetropolitanMap.curFLID;  //直线A点计数
    var j = MetropolitanMap.curFLID+1;  //直线B点计数
    var k = 0;  //垂足数组计数
    var fX = 0; //A X
    var fY = 0; //A Y
    var nX = 0; //B X
    var nY = 0; //B Y
    var footX = 0;  //垂足X
    var footY = 0;  //垂足Y
    var footDistance = 0;  //有垂足直线的ID
    var initID = 0;  //有垂足直线的原始ID
    var footArr = new Array();    //存有垂足线的数组:线ID,垂足距离（用于排序获取最小值）,垂足X,垂足Y
    var rLen = routePresetData.length;

    for (; i < rLen; i++) {
        fX = routePresetData[i].x;
        fY = routePresetData[i].y;
        nX = routePresetData[j].x;
        nY = routePresetData[j].y;
        //判断是否为最后一段,如果是则i-1为ID,因为最后一点为最后一个线的末点
        var footPoint = getVerticalFoot(fX, fY, nX, nY, curPointX, curPointY);
        if (i > rLen - 3) {
            if (footPoint != null) {
                initID = routePresetData[i].initID;   //获得原始ID
                footX = footPoint.x;   //获得垂足X轴
                footY = footPoint.y;   //获得垂足Y轴
                footDistance = getPointDistance(curPointX, curPointY, footX, footY);    //获得垂足到当前点的距离
                footArr[k] = new Array(initID, footDistance, routePresetData[rLen - 1].x, routePresetData[rLen - 1].y);  //将有垂足的直线放入数组
            }
            break;
        } else {
            if (footPoint != null) {
                initID = routePresetData[i].initID;   //获得原始ID
                footX = footPoint.x;   //获得垂足X轴
                footY = footPoint.y;   //获得垂足Y轴
                footDistance = getPointDistance(curPointX, curPointY, footX, footY);    //获得垂足到当前点的距离
                footArr[k] = new Array(initID, footDistance, footX, footY);  //将有垂足的直线放入数组
                k++;
            }
        }
        j++;
    }

    var m, n, temp;
    //得到排序二维数组长度
    var len = footArr.length;
    //用冒泡排序法将二维表中记录按从小到大排序,按追加的距离字段排序,排序字段为3
    for (m = 1; m < len; m++) {
        for (n = 0; n < len - m; n++) {
            if (parseFloat(footArr[n][1]) > parseFloat(footArr[n + 1][1])) {
                temp = footArr[n];
                footArr[n] = footArr[n + 1];
                footArr[n + 1] = temp;
            }
        }
    }
    //==========对数组排序得出最短垂足 END==========    

    var maxFoot = 30;   //限定垂足有效范围,主要用于防止倒退
    //var maxFoot = 60;   //限定垂足有效范围,主要用于防止倒退
    if (footArr != "" && footArr[0][1] < maxFoot) {
        return { initID: footArr[0][0], footDistance: footArr[0][1], x: footArr[0][2], y: footArr[0][3] };
    } else {
        return null;
    }
}
